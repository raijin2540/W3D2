require_relative 'requires'

class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    question_follow = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    return nil unless question_follow.length > 0

    QuestionFollow.new(question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    users = QuestionsDatabaseConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL

    return nil unless users.length > 0
    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL

    return nil unless questions.length > 0

    questions.map { |question| Question.new(question) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
