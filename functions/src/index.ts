import * as functions from "firebase-functions";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

initializeApp();

const firestore = getFirestore();

export const newOpportunity = functions.firestore
  .document("opportunities/{opportunityId}")
  .onCreate((snap, context) => {
    const opportunity = snap.data();
    functions.logger.log("title:", opportunity["title"]);
    return opportunity;
  });
