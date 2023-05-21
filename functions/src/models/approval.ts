import { Opportunity, OpportunityType } from "./opportunity";

export class Approval {
  opportunity: Opportunity;
  ratings: number[];
  comments: string;

  constructor(opportunity: Opportunity, ratings: number[], comments: string) {
    this.opportunity = opportunity;
    this.ratings = ratings;
    this.comments = comments;
  }

  get credits(): number {
    return this.opportunity.credits;
  }

  get isProject(): boolean {
    return this.opportunity.opportunityType === OpportunityType.Project;
  }

  get isService(): boolean {
    return this.opportunity.opportunityType === OpportunityType.Service;
  }

  get isTutoring(): boolean {
    return this.opportunity.opportunityType === OpportunityType.Tutoring;
  }

  static fromJson(json: any): Approval {
    return new Approval(
      Opportunity.fromJson(json["opportunity"]),
      json["ratings"],
      json["comments"]
    );
  }

  toJson(): any {
    return {
      opportunity: this.opportunity.toJson(),
      ratings: this.ratings,
      comments: this.comments,
    };
  }
}
