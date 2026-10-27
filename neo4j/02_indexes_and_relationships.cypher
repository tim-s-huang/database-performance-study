// 02 - Lookup indexes, then relationships between nodes

CREATE INDEX badge_user_id_index FOR (b:Badges) on (b.user_id);
CREATE INDEX comment_post_id_index FOR (c:Comments) on (c.post_id);
CREATE INDEX comment_user_id_index FOR (c:Comments) on (c.user_id);
CREATE INDEX question_user_id_index FOR (q:Questions) on (q.owner_user_id);
CREATE INDEX answer_user_id_index FOR (a:Answers) on (a.owner_user_id);
CREATE INDEX answer_parent_id_index FOR (a:Answers) on (a.parent_id);
CREATE INDEX question_accepted_id_index FOR (q:Questions) on (q.accepted_answer_id);

// Users -> [POSTED] -> Answers with u.id and a.owner_user_id
MATCH (u:Users), (a:Answers)
WHERE u.id = a.owner_user_id
CREATE (u)-[:POSTED]->(a);

// Users -> [ACHIEVED] -> Badges with u.id and b.user_id
MATCH (u:Users), (b:Badges)
WHERE u.id = b.user_id
CREATE (u)-[:ACHIEVED]->(b);

// Users -> [POSTED] -> Questions  with u.id and q.owner_user_id
MATCH (u:Users), (q:Questions)
WHERE u.id = q.owner_user_id
CREATE (u)-[:POSTED]->(q);

// Users -> [POSTED] -> Comments with u.id and c.user_id
MATCH (u:Users), (c:Comments)
WHERE u.id = c.user_id
CREATE (u)-[:POSTED]->(c);

// Questions -> [ACCEPTED_ANS] -> Answers with q.accepted_answer_id and a.id
MATCH (q:Questions), (a:Answers)
WHERE q.accepted_answer_id = a.id
CREATE (q)-[:ACCEPTED_ANS]->(a);

// Answers -> [ANS_TO] -> Questions with a.parent_id and q.id
MATCH (a:Answers), (q:Questions)
WHERE a.parent_id = q.id
CREATE (a)-[:ANS_TO]->(q);

// Comments -> [REPLIED_TO] -> Answers with c.post_id and a.id
MATCH (c:Comments), (a:Answers)
WHERE c.post_id = a.id
CREATE (c)-[:REPLIED_TO]->(a);

// Comments -> [REPLIED_TO] - Questions with c.post_id and q.id
MATCH (c:Comments), (q:Questions)
WHERE c.post_id = q.id
CREATE (c)-[:REPLIED_TO]->(q);
