import { v4 as uuidv4 } from "uuid";

export enum OpportunityType {
  Project = "project",
  Service = "service",
  Tutoring = "tutoring",
}

export class MemberSnippet {
  id: string;
  name: string;
  email: string;
  profilePicture: string;

  constructor(id: string, name: string, email: string, profilePicture: string) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.profilePicture = profilePicture;
  }

  static fromJson(json: any): MemberSnippet {
    return new MemberSnippet(
      json["id"],
      json["name"],
      json["email"],
      json["profilePicture"]
    );
  }

  toJson(): any {
    return {
      id: this.id,
      name: this.name,
      email: this.email,
      profilePicture: this.profilePicture,
    };
  }
}

export class Opportunity {
  id: string;
  creatorId: string;
  creatorName: string;
  department: string;
  title: string;
  description: string;
  date: Date;
  period: number;
  opportunityType: OpportunityType;
  credits: number;
  membersNeeded: number;
  numMembersSignedUp: number;
  membersSignedUp: MemberSnippet[];

  constructor(
    id = uuidv4(),
    creatorId: string,
    creatorName: string,
    title: string,
    description: string,
    date: Date,
    opportunityType: OpportunityType,
    period = 1,
    credits = 1,
    membersNeeded = 1,
    numMembersSignedUp = 0,
    membersSignedUp: MemberSnippet[] = []
  ) {
    this.id = id;
    this.creatorId = creatorId;
    this.creatorName = creatorName;
    this.department = "";
    this.title = title;
    this.description = description;
    this.date = date;
    this.period = period;
    this.opportunityType = opportunityType;
    this.credits = credits;
    this.membersNeeded = membersNeeded;
    this.numMembersSignedUp = numMembersSignedUp;
    this.membersSignedUp = membersSignedUp;
  }

  static fromJson(json: any): Opportunity {
    return new Opportunity(
      json["id"],
      json["creatorId"],
      json["creatorName"],
      json["title"],
      json["description"],
      new Date(json["date"]),
      json["opportunityType"],
      json["period"],
      json["credits"],
      json["membersNeeded"],
      json["numMembersSignedUp"],
      json["membersSignedUp"].map((memberJson: any) =>
        MemberSnippet.fromJson(memberJson)
      )
    );
  }

  toJson(): any {
    return {
      creatorId: this.creatorId,
      creatorName: this.creatorName,
      title: this.title,
      description: this.description,
      date: this.date.toISOString(),
      period: this.period,
      opportunityType: this.opportunityType,
      credits: this.credits,
      membersNeeded: this.membersNeeded,
      numMembersSignedUp: this.numMembersSignedUp,
      membersSignedUp: this.membersSignedUp.map((member: MemberSnippet) =>
        member.toJson()
      ),
    };
  }
}

export class ServiceSnippet {
  opportunityId: string;
  title: string;
  date: Date;
  period: number;
  rating?: number;
  credits?: number;

  constructor(
    opportunityId: string,
    title: string,
    date: Date,
    period: number,
    rating?: number,
    credits?: number
  ) {
    this.opportunityId = opportunityId;
    this.title = title;
    this.date = date;
    this.period = period;
    this.rating = rating;
    this.credits = credits;
  }

  static fromJson(json: any): ServiceSnippet {
    return new ServiceSnippet(
      json["opportunityId"],
      json["title"],
      new Date(json["date"]),
      json["period"],
      json["rating"],
      json["credits"]
    );
  }

  toJson(): any {
    const json: Record<string, any> = {
      opportunityId: this.opportunityId,
      title: this.title,
      date: this.date.toISOString(),
      period: this.period,
    };
    if (this.credits != undefined) json["credits"] = this.credits;
    if (this.rating != undefined) json["rating"] = this.rating;
    return json;
  }

  static fromOpportunity(opportunity: Opportunity): ServiceSnippet {
    return new ServiceSnippet(
      opportunity.id,
      opportunity.title,
      opportunity.date,
      opportunity.period
    );
  }
}
