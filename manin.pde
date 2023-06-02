/**
  Andoni ALONSO TORT
  UNIVERSITÉ DU HAVRE NORMANDIE
  M1 IWOCS INFORMATIQUE
  COMPILATION
*/
String[][] tab = {};
String[][] gramaire = {};
String[] code;
String[] pile = {"$"};
int initX = 20;

void setup() {
  size(900, 750);
  tab = readTableFile("tableauGramaire.txt");
  gramaire = readTableFile("gramaire.txt");
  code = loadStrings("entree.txt");
  for(int i = 0 ; i < code.length ; i++) {
    println(code[i]);
  }
  
  
}

/**
  Methode pur lire un fichier et le retourner dans un tableau de deux dimensions
*/
String[][] readTableFile(String src) {
  String[][] table = {};
  String[] lignes = loadStrings(src);
  boolean valid = false;
  
  for(int i = 0 ; i < lignes.length ; i++) {
    String[] parties = split(lignes[i], ' ');
    String s = "Ligne " + i + " : ";
     if(!valid) {
       table = new String[lignes.length][parties.length];
       valid = true;
     }
     println(parties.length);
    for(int j = 0 ; j < parties.length ; j++) {
      table[i][j] = parties[j];
       s += "| " + parties[j] + " |";
    }
    //println(s);
  }
  
  for(int i = 0 ; i < table.length ; i++) {
    println(table[i]);
  }
  return table;
}

void draw() {
  background(10);
  
  // Afficher l'entree
  fill(200); // définit la couleur de remplissage à noir pour le texte
  textSize(50);
  textAlign(CENTER, CENTER); // centre le texte dans la boîte
  String s = "";
  for(int i = 0 ; i < code.length; i++) {
    s += code[i];
  }
  text(s, width/2, 50);
  textSize(20);
  
  int x = initX;
  int x2 = 50;
  int y = 500;
  int y2 = 30;
  for(int i = 0 ; i < pile.length; i++) {
    fill(255, 255, 255);
    rect(x, y, x2, y2);
    
    fill(0); // définit la couleur de remplissage à noir pour le texte
    textAlign(CENTER, CENTER); // centre le texte dans la boîte
    text(pile[i], x+x2/2, y+y2/2); // affiche le texte dans la boîte
  }
  
  
    
}
