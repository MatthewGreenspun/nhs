//TODO: load from firebase remote config
const kTutoringSubjects = {
  "Math": [
    "Algebra I",
    "Geometry",
    "H. Geometry",
    "Algebra II/Trig",
    "H. Algebra II/Trig",
    "Precalculus",
    "H. Precalculus",
    "Calculus",
    "AP Calculus AB",
    "AP Calculus BC",
    "AP Computer Science",
    "Statistics",
    "AP Statistics",
  ],
  "Science": [
    "Biology",
    "H. Biology",
    "AP Biology",
    "Post-AP Genetics",
    "Chemistry",
    "H. Chemistry",
    "AP Chemistry",
    "Physics",
    "AP Physics I",
    "AP Physics II",
    "AP Physics C",
    "AP Psychology",
  ],
  "Social Studies": [
    "Global History 9",
    "Global History 10",
    "AP World History",
    "AP European History",
    "AP Human Geography",
    "US History",
    "AP US History",
    "US Government and Politics",
    "AP US Government with Economics",
    "AP Comparative Government",
    "AP Microeconomics",
    "AP Macroeconomics",
    "AP Economics w/ Gov (Mic/Mac)",
  ],
  "English": [
    "English 9",
    "English 10",
    "English 11",
    "Journalism",
    "AP English Language and Composition",
    "English 12",
    "AP English Literature Creative Writing",
    "AP English Literature Traditions",
  ],
  "Languages": [
    "Chinese 1",
    "Chinese 2",
    "Chinese 3",
    "AP Chinese",
    "Spanish 1",
    "Spanish 2",
    "Spanish 3",
    "AP Spanish",
    "French 1",
    "French 2",
    "French 3",
    "AP French",
    "Latin 1",
    "Latin 2",
    "Latin 3",
    "AP Latin",
    "Japanese 1",
    "Japanese 2",
    "Japanese 3",
    "AP Japanese",
  ],
  "Other": [
    "Time Management Help",
    "SAT Prep",
    "ACT Prep",
  ]
};

const kDepartments = [
  "Art",
  "Biology",
  "English",
  "Mathematics and Computer Science",
  "Music",
  "Physical Science and Engineering",
  "Social Studies",
  "World Languages",
  "Physical Education",
  "Administration",
  "Custodial",
  "Guidance",
  "School Aides",
  "Secretaries",
  "Security",
  "Technology",
];

const kDaysOfTheWeek = [
  "",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday"
];

const kMemberOpportunityChipFilters = ["All", "Project", "Service", "Tutoring"];

const kAdminOpportunityChipFilters = [
  "All",
  "Project",
  "Service",
  "Tutoring",
  "Past"
];

const kCreditsNeeded = 15;
