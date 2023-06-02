/**
  Andoni ALONSO TORT
  UNIVERSITÉ DU HAVRE NORMANDIE
  M1 IWOCS INFORMATIQUE
  COMPILATION
*/
String[][] tab = {};
String[][] gramaire = {};
String code;
String[] pile = {"$"};

void setup() {
  tab = readTableFile("tableauGramaire.txt");
  gramaire = readTableFile("gramaire.txt");
  String[] code = loadStrings("entree.txt");
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
  
}
