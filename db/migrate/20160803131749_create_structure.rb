class CreateStructure < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.integer :vote_count, default: 0
      t.float :coeff, default: 0.0
      t.boolean :multiple, default: false
      t.timestamps
    end

    create_table :comments do |t|
      t.belongs_to :question
      t.integer :user_id
      t.string :comment
      t.timestamps
    end

    create_table :answers do |t|
      t.belongs_to :question
      t.integer :answer_number
      t.string :answer
    end

    create_table :answer_points do |t|
      t.belongs_to :answer, index: true
      t.belongs_to :spe, index: true
      t.integer :score, default: 0
    end

    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phonenumber
      t.date :birthday
      t.string :gender
      t.string :token
      t.integer :godfather_id
    end

    create_table :users_answers do |t|
      t.integer :question_id
      t.integer :answer_number
      t.integer :user_id
    end

    create_table :spes do |t|
      t.string :username
      t.string :full_name
      t.string :email
      t.string :key
      t.boolean :elligible, default: true
    end

    create_table :votes do |t|
      t.belongs_to :question
      t.belongs_to :spe
      t.integer :vote, default: 0
    end

    create_table :suggested_coeffs do |t|
      t.belongs_to :question
      t.belongs_to :spe
      t.integer :coeff, default: 0
    end

    create_table :config_vars do |t|
      t.string :name
      t.string :value
    end

    create_table :logs do |t|
      t.boolean :reversible, default: false
      t.integer :category
      t.string :description
      t.string :blob
      t.timestamps
    end

    create_table :connection_logs do |t|
      t.belongs_to :spe
      t.timestamps
    end

    create_table :access_tokens do |t|
      t.string :token, null: false
      t.integer :level, null: false, default: 0
      t.string :voucher, default: nil
    end

    create_table :announcements do |t|
      t.string :content
      t.timestamps
    end
  end
end
