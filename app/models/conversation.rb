class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  #会話の送り手がユーザモデルから参照できるようにアソシエーションを設定

  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  #会話の受け手がユーザモデルから参照できるようにアソシエーションを設定

  has_many :messages, dependent: :destroy
  #会話は複数のメッセージを保有し、会話が削除されたらメッセージも削除する

  validates_uniqueness_of :sender_id, scope: :recipient_id
  #送り手は受け手と重複しないことを制御しチェックする
  #validates_uniqueness_of は、属性の値が一意であることを検証するメソッド

  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end

  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end
