class CleanUsersAnswers < ActiveRecord::Migration
  def change
    # HARDCODE
    students = %i(abecassis athor azizian beaulieu boutin bruneaux brunod
bustillo careil chardon cortes diridollou dumond fievet flechelles
gaborit georges godefroy haas khalfallah lanfranchi lecat ledaguenel laigret
lengele lequen lerbet lezanne lozach medmoun nguyen preumont qrichi rabineau ravetta rael
ren robina robind sahli scotti sourice steiner thomas vanel vital zhou)

    students.each do |s|
      remove_column :users_answers, s, :integer
    end
    add_column :users_answers, :user_id, :integer
    rename_column :users, :username, :token
  end
end
