class CreateStructure < ActiveRecord::Migration
  def change
    students = %i(abecassis athor azizian beaulieu boutin bruneaux brunod
bustillo careil chardon cortes diridollou dumond fievet flechelles
gaborit georges godefroy haas khalfallah lanfranchi lecat ledaguenel laigret
lengele lequen lerbet lezanne lozach medmoun nguyen preumont qrichi rabineau ravetta rael
ren robina robind sahli scotti sourice steiner thomas vanel vital zhou)

    create_table :questions do |t|
      t.string :question
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

      students.each do |sym|
        t.integer sym, default: 0
      end
    end

    create_table :users do |t|
      t.string :username
      t.string :email
    end

    create_table :users_answers do |t|
      t.integer :question_id
      t.integer :answer_number

      students.each do |sym|
        t.integer sym
      end
    end

    create_table :spes do |t|
      t.string :username
      t.string :full_name
      t.string :key
    end
  end
end
