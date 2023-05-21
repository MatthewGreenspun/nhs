import * as functions from "firebase-functions";
import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { Approval } from "./models/approval";
import { Member } from "./models/member";
import { ServiceSnippet } from "./models/opportunity";
import { calcMean } from "./utils";

initializeApp();

const firestore = getFirestore();
export const handleApproval = functions.https.onCall(async (data) => {
  const approval = Approval.fromJson(data);
  await firestore.collection("approvals").add(approval.toJson());
  await firestore
    .collection("opportunities")
    .doc(approval.opportunity.id)
    .set({ isCompleted: true }, { merge: true });
  const creatorDoc = await firestore
    .collection("users")
    .doc(approval.opportunity.creatorId)
    .get();
  const postSnippets = (creatorDoc.data()!["posts"] as any[]).map((post) => {
    if (post.opportunityId === approval.opportunity.id) {
      return new ServiceSnippet(
        post.opportunityId,
        post.title,
        new Date(post.date),
        post.period,
        calcMean(approval.ratings)
      );
    }
    return ServiceSnippet.fromJson(post);
  });
  await creatorDoc.ref.set(
    { posts: postSnippets.map((s) => s.toJson()) },
    { merge: true }
  );

  const memberSnippets = approval.opportunity.membersSignedUp;
  // This performs a document read for each member that signed up.
  // It's okay in this case because this function won't run very often
  // This is necessary because we need to update member's service snippet
  const memberDocs = await Promise.all(
    memberSnippets.map((m) => firestore.collection("users").doc(m.id).get())
  );
  memberDocs.forEach((doc, idx) => {
    const member = Member.fromJson(doc.data());
    const updatedServiceSnippets = member.opportunities.map(
      (serviceSnippet) => {
        if (serviceSnippet.opportunityId === approval.opportunity.id) {
          return new ServiceSnippet(
            serviceSnippet.opportunityId,
            serviceSnippet.title,
            serviceSnippet.date,
            serviceSnippet.period,
            approval.ratings[idx],
            approval.credits
          );
        }
        return serviceSnippet;
      }
    );
    // TODO: notify admins if the student was given < 3 stars
    if (approval.ratings[idx] < 3) {
      doc.ref.set(
        {
          opportunities: updatedServiceSnippets.map((s) => s.toJson()),
        },
        { merge: true }
      );
      return;
    }
    doc.ref.set(
      {
        projectCredits: FieldValue.increment(
          approval.isProject ? approval.credits : 0
        ),
        serviceCredits: FieldValue.increment(
          approval.isService ? approval.credits : 0
        ),
        tutoringCredits: FieldValue.increment(
          approval.isTutoring ? approval.credits : 0
        ),
        opportunities: updatedServiceSnippets.map((s) => s.toJson()),
      },
      { merge: true }
    );
  });
});
