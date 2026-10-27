// 02 - The same questions answered against each design, timed with explain("executionStats")
// Query 2i: users awarded "Nice Question" since 2020, their questions and each accepted answer's score (120 results in both designs)
// Query 2ii: as 2i, plus the comments on each accepted answer (17 results in both designs)

// Query 2i on database_a (referenced): executionTimeMillis = 44
db = db.getSiblingDB("database_a");
db.Badges.aggregate(
[
  {
    $match: {
      date: {
        $gt: ISODate("2020-01-01T00:00:00Z")
      },
      name: "Nice Question"
    }
  },
  {
    $lookup: {
      from: "Users",
      localField: "user_id",
      foreignField: "id",
      as: "user"
    }
  },
  {
    $unwind: {
      path: "$user"
    }
  },
  {
    $lookup: {
      from: "Questions",
      localField: "user_id",
      foreignField: "owner_user_id",
      as: "Owner_Questions"
    }
  },
  {
    $unwind: {
      path: "$Owner_Questions"
    }
  },
  {
    $lookup: {
      from: "Answers",
      localField:
        "Owner_Questions.accepted_answer_id",
      foreignField: "id",
      as: "Question_Answers"
    }
  },
  {
    $unwind: {
      path: "$Question_Answers"
    }
  },
  {
    $project: {
      user_id: 1,
      user_display_name: "$user.display_name",
      badge_name: "$name",
      badge_date: "$date",
      question_id: "$Owner_Questions.id",
      question_title: "$Owner_Questions.title",
      accepted_answer_id: "$Question_Answers.id",
      accepted_answer_score:
        "$Question_Answers.score"
    }
  }
]
).explain("executionStats");

// Query 2i on database_b (embedded): executionTimeMillis = 33
db = db.getSiblingDB("database_b");
db.Badges_emb.aggregate(
[
  {
    $match: {
      date: {
        $gt: ISODate("2020-01-01T00:00:00Z")
      },
      name: "Nice Question"
    }
  },
  {
    $lookup: {
      from: "Questions_emb",
      localField: "user_id",
      foreignField: "owner_user_id",
      as: "Owner_Questions"
    }
  },
  {
    $unwind: "$Owner_Questions"
  },
  {
    $project: {
      user_id: 1,
      user_display_name: "$user.display_name",
      badge_name: "$name",
      badge_date: "$date",
      question_id: "$Owner_Questions.id",
      question_title: "$Owner_Questions.title",
      accepted_answer_id:
        "$Owner_Questions.accepted_answer.id",
      accepted_answer_score:
        "$Owner_Questions.accepted_answer.score"
    }
  },
  {
    $match: {
      accepted_answer_id: {
        $exists: true,
        $ne: null
      },
      accepted_answer_score: {
        $exists: true,
        $ne: null
      }
    }
  }
]
).explain("executionStats");

// Query 2ii on database_a (referenced): executionTimeMillis = 47
db = db.getSiblingDB("database_a");
db.Badges.aggregate(
[
  {
    $match: {
      date: {
        $gt: ISODate("2020-01-01T00:00:00Z")
      },
      name: "Nice Question"
    }
  },
  {
    $lookup: {
      from: "Users",
      localField: "user_id",
      foreignField: "id",
      as: "user"
    }
  },
  {
    $unwind: {
      path: "$user"
    }
  },
  {
    $lookup: {
      from: "Questions",
      localField: "user_id",
      foreignField: "owner_user_id",
      as: "Owner_Questions"
    }
  },
  {
    $unwind: {
      path: "$Owner_Questions"
    }
  },
  {
    $lookup: {
      from: "Answers",
      localField:
        "Owner_Questions.accepted_answer_id",
      foreignField: "id",
      as: "Question_Answers"
    }
  },
  {
    $unwind: {
      path: "$Question_Answers"
    }
  },
  {
    $lookup: {
      from: "Comments",
      localField: "Question_Answers.id",
      foreignField: "post_id",
      as: "Answer_Comments"
    }
  },
  {
    $unwind: {
      path: "$Answer_Comments"
    }
  },
  {
    $project: {
      user_id: 1,
      question_id: "$Owner_Questions.id",
      accepted_answer_id: "$Question_Answers.id",
      answer_comment_id: "$Answer_Comments.id"
    }
  }
]
).explain("executionStats");

// Query 2ii on database_b (embedded): executionTimeMillis = 29
db = db.getSiblingDB("database_b");
db.Badges_emb.aggregate(
[
  {
    $match: {
      date: {
        $gt: ISODate("2020-01-01T00:00:00Z")
      },
      name: "Nice Question"
    }
  },
  {
    $lookup: {
      from: "Questions_emb",
      localField: "user_id",
      foreignField: "owner_user_id",
      as: "Owner_Questions"
    }
  },
  {
    $unwind: "$Owner_Questions"
  },
  {
    $project: {
      user_id: 1,
      question_id: "$Owner_Questions.id",
      accepted_answer_id:
        "$Owner_Questions.accepted_answer.id",
      accepted_answer_comment_id:
        "$Owner_Questions.accepted_answer.comments.id"
    }
  },
  {
    $unwind: "$accepted_answer_comment_id"
  }
]
).explain("executionStats");
