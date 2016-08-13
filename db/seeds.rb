# coding: utf-8
require 'digest/sha1'
def generate_key(data)
  (Digest::SHA1.hexdigest "#{data[0]}<#{data[2]}>\n")[0..5]
end

spes = [
  ["lengele", "Jérémy Lengelé", "jeremylengele@gmail.com"],
  ["beaulieu", "Clément Beaulieu", "beaulieuclement777@gmail.com"],
  ["thomas", "Hugo Thomas", "hugo.thomas89@gmail.com"],
  ["bustillo", "Pablo Bustillo Vazquez", "pbustillo05@gmail.com"],
  ["rael", "Anton Raël", "anton.rael@hotmail.fr"],
  ["flechelles", "Balthazar Fléchelles", "balthazar.flechelles@gmail.com"],
  ["gaborit", "Florence Gaborit", "florence@gaborit.net"],
  ["nguyen", "Laura NGuyen", "lauranguyen@rocketmail.com"],
  ["haas", "David Haas", "davhaas98@gmail.com"],
  ["diridollou", "Loïc Diridollou", "loic.diridollou@gmail.com"],
  ["careil", "Marlène Careil", "marlene.careil123@gmail.com"],
  ["zhou", "Yunfan Zhou", "yunfan1996@gmail.com"],
  ["preumont", "Laurane Preumont", "laurane@preumont.com"],
  ["lecat", "Grégoire Lecat", "gregoire.lecat@wanadoo.fr"],
  ["lanfranchi", "Clémence Lanfranchi", "clemence.lanfranchi@gmail.com"],
  ["georges", "Nicolas Georges", "nicolas.georges59travail@gmail.com"],
  ["sourice", "Nolwenn Sourice", "nolwennsourice@gmail.com"],
  ["dumond", "J-A Dumond", "jean-alexandre.dumond@orange.fr"],
  ["chardon", "Hugo Chardon", "hugo.chardon@orange.fr"],
  ["ledaguenel", "Arthur Ledaguenel", "arthur.ledaguenel@orange.fr"],
  ["lequen", "Arnaud Lequen", "arnaud.lequen@gmail.com"],
  ["abecassis", "Lison Abécassis", "lison.abecassis@gmail.com"],
  ["ravetta", "Antoine Ravetta", "antoine.ravetta@orange.fr"],
  ["athor", "Grégory Athor", "gregory.athor@gmail.com"],
  ["medmoun", "Mehdi Medmoun", "mehdimedmoun@gmail.com"],
  ["steiner", "Joanne Steiner", "joannesteiner@hotmail.fr"],
  ["brunod", "Luca Brunod Indrigo", "lu.k@sfr.fr"],
  ["cortes", "Oscar Cortés Azuero", "o.cortes.azuero@gmail.com"],
  ["vanel", "Mélina Vanel", "melina.vanel@yahoo.fr"],
  ["lerbet", "Samuel Lerbet", "samuel.lerbet1@hotmail.fr"],
  ["sahli", "Skandère Sahli", "skandere.sahli@gmail.com"],
  ["rabineau", "guillaume rabineau", "guillaume.rabineau49@gmail.com"],
  ["robina", "Arnaud Robin", "arnaud-robin@hotmail.fr"],
  ["scotti", "Martin Scotti", "martin.scotti.fr@gmail.com"],
  ["ren", "Isaac Ren", "gopi3.1415@gmail.com"],
  ["boutin", "Simon Boutin", "simonboutin@hotmail.fr"],
  ["fievet", "Baptiste Fievet", "baptiste.fievet@laposte.net"],
  ["lozach", "Mathilde Lozac'h", "mathilde.lozach@gmail.com"],
  ["vital", "Loïc Vital", "loc.vital@orange.fr"],
  ["godefroy", "Henri Godefroy", "henri_godefroy@sfr.fr"],
  ["khalfallah", "Élie Khalfallah", "ekhalfallah@gmail.com"],
  ["laigret", "Sébastien Laigret", "sebastien.laigret@orange.fr"],
  ["robind", "David Robin", "david.robin97@gmail.com"],
  ["bruneaux", "Margot Bruneaux", "margot.bruneaux@gmail.com"],
  ["azizian", "Waïss Azizian", "waissfowl@gmail.com"],
  ["qrichi", "Myriam Qrichi Aniba", "myriam.qrichi@gmail.com"],
  ["lezanne", "Clément Lezanne", "wanly@live.fr"]
]

spes.each do |info|
  s = Spe.new(username: info[0], full_name: info[1], key: generate_key(info))
  s.save
end
