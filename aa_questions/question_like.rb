require_relative 'requires'

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    question_like = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    return nil unless question_like.length > 0

    QuestionLike.new(question_like.first)
  end

  def self.likers_for_question_id(question_id)
    users = QuestionsDatabaseConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL

    return nil unless users.length > 0
    users.map { |user| User.new(user)}
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabaseConnection.instance.execute(<<-SQL, question_id)

      SELECT
        COUNT(id)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    num_likes.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    liked_questions = QuestionsDatabaseConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        user_id = ?
    SQL

    return nil unless liked_questions.length > 0

    liked_questions.map { |liked_question| Question.new(liked_question) 
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end


end
