require_relative 'requires'

class Reply
  attr_accessor :id, :question_id,:parent_id, :user_id, :body

  def self.find_by_id(id)
    reply = QuestionsDatabaseConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    return nil unless reply.length > 0

    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    return nil unless replies.length > 0

    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)

    replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    return nil unless replies.length > 0

    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Repy.find_by_id(self.parent_id)
  end

  def child_replies
    replies = QuestionsDatabaseConnection.instance.execute(<<-SQL, @question_id, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ? AND id > ?
      LIMIT 1
    SQL

    return nil unless replies.length > 0

    Reply.new(replies.first)
  end

end
