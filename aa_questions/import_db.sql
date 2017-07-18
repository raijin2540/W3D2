DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER, --doesnt need to have a parent
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_id) REFERENCES replies(id)
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jin', 'Ooi'),
  ('Frankie', 'Ziman'),
  ('Billy', 'Bob'),
  ('Lilly', 'Jane'),
  ('Jane', 'Doe');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Cats', 'What color is your cat?', (SELECT id FROM users WHERE fname = 'Jin' AND lname = 'Ooi')),
  ('Hello', 'HELLO???', (SELECT id FROM users WHERE fname = 'Frankie' AND lname = 'Ziman'));

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title LIKE 'cats') , NULL, (SELECT id FROM users WHERE fname = 'Jin'), 'gray'),
  ((SELECT id FROM questions WHERE title LIKE 'hello'), NULL, (SELECT id FROM users WHERE fname = 'Frankie'), 'HERE');

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title LIKE 'cats') , (SELECT id FROM replies WHERE body LIKE 'gray'), (SELECT id FROM users WHERE fname = 'Jin'), 'not here');

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Jin'),(SELECT id FROM questions WHERE title LIKE 'cats')),
  ((SELECT id FROM users WHERE fname = 'Frankie'),(SELECT id FROM questions WHERE title LIKE 'hello')),
  ((SELECT id FROM users WHERE fname = 'Billy'),(SELECT id FROM questions WHERE title LIKE 'hello')),
  ((SELECT id FROM users WHERE fname = 'Lilly'),(SELECT id FROM questions WHERE title LIKE 'hello')),
  ((SELECT id FROM users WHERE fname = 'Jane'),(SELECT id FROM questions WHERE title LIKE 'hello'));

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1,2);
