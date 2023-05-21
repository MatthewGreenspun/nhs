import { ServiceSnippet } from "./opportunity";

export class Member {
  role: string = "member";
  name: string;
  email: string;
  graduationYear: number;
  projectCredits: number;
  serviceCredits: number;
  tutoringCredits: number;
  probationLevel: number;
  tutoringSubjects: string[];
  freePeriods: { [key: number]: string[] };
  opportunities: ServiceSnippet[];

  constructor(
    name: string,
    email: string,
    graduationYear: number,
    projectCredits: number = 0,
    serviceCredits: number = 0,
    tutoringCredits: number = 0,
    probationLevel: number = 0,
    tutoringSubjects: string[] = [],
    freePeriods: { [key: number]: string[] } = {},
    opportunities: ServiceSnippet[] = []
  ) {
    this.name = name;
    this.email = email;
    this.graduationYear = graduationYear;
    this.projectCredits = projectCredits;
    this.serviceCredits = serviceCredits;
    this.tutoringCredits = tutoringCredits;
    this.probationLevel = probationLevel;
    this.tutoringSubjects = tutoringSubjects;
    this.freePeriods = freePeriods;
    this.opportunities = opportunities;
  }

  static fromJson(json: any): Member {
    return new Member(
      json["name"],
      json["email"],
      json["graduationYear"],
      json["projectCredits"],
      json["serviceCredits"],
      json["tutoringCredits"],
      json["probationLevel"],
      json["tutoringSubjects"],
      json["freePeriods"],
      json["opportunities"].map((serviceSnippetJson: any) =>
        ServiceSnippet.fromJson(serviceSnippetJson)
      )
    );
  }

  toJson(): any {
    return {
      role: this.role,
      name: this.name,
      email: this.email,
      graduationYear: this.graduationYear,
      projectCredits: this.projectCredits,
      serviceCredits: this.serviceCredits,
      tutoringCredits: this.tutoringCredits,
      probationLevel: this.probationLevel,
      tutoringSubjects: this.tutoringSubjects,
      freePeriods: this.freePeriods,
      opportunities: this.opportunities.map((serviceSnippet: ServiceSnippet) =>
        serviceSnippet.toJson()
      ),
    };
  }
}
