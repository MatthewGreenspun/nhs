import { describe, it } from "mocha";
import { expect } from "chai";
import {
  loadFirestoreRules,
  initializeTestApp,
  assertSucceeds,
} from "@firebase/testing";
import {
  initializeTestEnvironment,
  RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import fs from "fs";

const PROJECT_ID = "bronx-science-nhs-e9bcc";
const rules = fs.readFileSync("../../firestore.rules").toString();

loadFirestoreRules({
  projectId: PROJECT_ID,
  rules: rules,
});

const db = initializeTestApp({ projectId: PROJECT_ID }).firestore();

describe("Firebase rules", () => {
  it("Assign user roles", async () => {
    (await initializeTestEnvironment({ projectId: PROJECT_ID }))
      .withSecurityRulesDisabled;
    await db
      .collection("roles")
      .doc("greenspum@bxscience.edu")
      .set({ role: "staff" });
    const doc = db.collection("roles").doc("greenspum@bxscience.edu");
    assertSucceeds(doc.get());
  });
});
