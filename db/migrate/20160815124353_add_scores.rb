class AddScores < ActiveRecord::Migration
  def change
    students = %i(abecassis athor azizian beaulieu boutin bruneaux brunod
bustillo careil chardon cortes diridollou dumond fievet flechelles
gaborit georges godefroy haas khalfallah lanfranchi lecat ledaguenel laigret
lengele lequen lerbet lezanne lozach medmoun nguyen preumont qrichi rabineau ravetta rael
ren robina robind sahli scotti sourice steiner thomas vanel vital zhou)

    add_column :questions, :vote_count, :integer, default: 0
    add_column :questions, :coeff, :float, default: 0.0

    create_table :votes do |t|
      t.belongs_to :question
      students.each do |s|
        t.integer s, default: 0
      end
    end

    create_table :suggested_coeffs do |t|
      t.belongs_to :question
      students.each do |s|
        t.integer s, default: 0
      end
    end
  end
end
