// 01 - Constraints and CSV import (Stack Overflow sample dataset, not included)
// Place users.csv, badges.csv, questions.csv, answers.csv and comments.csv in Neo4j's import folder.

CREATE CONSTRAINT FOR (u:Users) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT FOR (b:Badges) REQUIRE b.id IS UNIQUE;
CREATE CONSTRAINT FOR (q:Questions) REQUIRE q.id IS UNIQUE;
CREATE CONSTRAINT FOR (c:Comments) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT FOR (a:Answers) REQUIRE a.id IS UNIQUE;



LOAD CSV WITH HEADERS FROM 'file:///badges.csv' AS row
MERGE (b:Badges {_id: row._id})
SET 
    b.name = row.name,
    b.id = toInteger(row.id),
    b.date = datetime(row.date),
    b.class = toInteger(row.class),
    b.tag_based = toBoolean(row.tag_based),
    b.user_id = toInteger(row.user_id)
RETURN count(b);

LOAD CSV WITH HEADERS FROM 'file:///users.csv' AS row
MERGE (u:Users {_id: row._id})
SET 
    u.display_name = row.display_name,
    u.id = toInteger(row.id),
    u.age = toInteger(row.age),
    u.creation_date = datetime(row.creation_date),
    u.downvotes = toInteger(row.down_votes),
    u.last_access_date = datetime(row.last_access_date),
    u.location = row.location,
    u.image = row.profile_image_url,
    u.reputation = toInteger(row.reputation),
    u.upvotes = toInteger(row.up_votes),
    u.views = toInteger(row.views), 
    u.website = row.website_url
RETURN count(u);


LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
MERGE (q:Questions {_id: row._id})
SET 
    q.id = toInteger(row.id),
    q.title = row.title,
    q.accepted_answer_id = toFloat(row.accepted_answer_id),
    q.answer_count = toInteger(row.answer_count),
    q.comment_count = toInteger(row.comment_count),
    q.creation_date = datetime(row.creation_date),  // Using datetime() for proper date format
    q.favorite_count = toFloat(row.favorite_count),
    q.last_activity_date = datetime(row.last_activity_date), // datetime() for standard format
    q.last_editor_user_id = toFloat(row.last_editor_user_id),
    q.owner_user_id = toInteger(row.owner_user_id),
    q.post_type_id = toInteger(row.post_type_id),
    q.score = toInteger(row.score),
    q.tags = row.tags,
    q.view_count = toInteger(row.view_count)
RETURN count(q);


LOAD CSV WITH HEADERS FROM 'file:///answers.csv' AS row
MERGE (a:Answers {_id: row._id})
SET 
    a.body = row.body,
    a.id = toInteger(row.id),
    a.comment_count = toInteger(row.comment_count),
    a.creation_date = datetime(row.creation_date), // Using datetime() for proper date format
    a.last_activity_date = datetime(row.last_activity_date), // datetime() for standard format
    a.last_editor_user_id = toInteger(row.last_editor_user_id),
    a.owner_user_id = toInteger(row.owner_user_id),
    a.parent_id = toInteger(row.parent_id),
    a.post_type_id = toInteger(row.post_type_id),
    a.score = toInteger(row.score)
RETURN count(a);



LOAD CSV WITH HEADERS FROM 'file:///comments.csv' AS row
MERGE (c:Comments {_id: row._id})
SET 
    c.id = toInteger(row.id),
    c.text = row.text,
    c.creation_date = datetime(row.creation_date), // Using datetime() for proper date format
    c.post_id = toInteger(row.post_id),
    c.user_id = toInteger(row.user_id),
    c.score = toInteger(row.score)
RETURN count(c);
