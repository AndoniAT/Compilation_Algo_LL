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
int initX = 0;
String[][] historique = {pile};
void setup() {
  size(1000, 800, P3D);
  surface.setTitle("Hello World!");
  surface.setResizable(true);
  
  // Lecture de la gramaire
  gramaire = readTableFile("gramaire.txt");
  
  // Lecture du tableau
  tab = readTableFile("tableauGramaire.txt");
  
  // Lecture de l'entree
  code = loadStrings("entree.txt");
 
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
     //println(parties.length);
    for(int j = 0 ; j < parties.length ; j++) {
      table[i][j] = parties[j];
       s += "| " + parties[j] + " |";
    }
    //println(s);
  }
  
  for(int i = 0 ; i < table.length ; i++) {
    //println(table[i]);
  }
  return table;
}

void draw() {
  background(200);
  
  //  == Afficher l'entree == 
    fill(0); // définit la couleur de remplissage à noir pour le texte
    textSize(40);
    textAlign(CENTER, CENTER); // centre le texte dans la boîte
    String s = "";
    for(int i = 0 ; i < code.length; i++) s += code[i];
    text(s, width/2, 50);
    textSize(15);
  // =======================
  
  // ==== GRAMAIRE =========
  pushMatrix();
    // Carré conteneur
    int X0 = 20;
    translate(X0, 100, 0); 
    noFill();
    fill(0);
    stroke(255);
    rect(0, 0, 200, (gramaire.length*20) + 40);  // Dessine le carré
    
    // Gramaire texte
    float initY = 10;
    fill(255);
    textSize(30);
    text(" GRAMAIRE : ", 100, initY);
    textSize(15);
    initY+=40;
    textAlign(LEFT);
    for(int i = 0 ; i < gramaire.length; i++) {
        String gram = "("+int(i+1)+") ";
        
        for(int j = 0 ; j < gramaire[i].length; j++) {
           gram+= gramaire[i][j] != null ? gramaire[i][j].equals(":") ? " => " : gramaire[i][j] + " " : "";
        }
    
        // Definir la couleur de remplissage à noir pour le texte
        fill(255); 
        text(gram, 10, initY); 
        initY+=20;  
    }
    initY+=40;
    textSize(35);
    fill(0);
    text("<=               =>", 10, initY);
    textSize(15);
    initY+=20;
    textAlign(CENTER, CENTER);
    text("Utilisez les fleches de votre clavier \n pour faire evoluer la pile", 100, initY);
    textSize(15);  
  popMatrix();
  
  // ======================
  // == TABLE ==
  pushMatrix();
    translate(250, 100, 0); 
    noFill();
    fill(190);
    stroke(255);
    rect(0, 0, tab.length*35, (gramaire.length*32));  // Dessine le carré
    
    // Table
    float yLigne = 15;
    for(int i = 0 ; i < tab.length ; i++) {
      float xCol = 28;
      for(int j = 0 ; j < tab[i].length ; j++) {
        fill(0); 
        text(tab[i][j], xCol, yLigne);
        xCol+=60;
      }
      yLigne+=20;
      
    }
  
  popMatrix();
  // ======================
  
  // == PILE HISTORIQUE =======
  pushMatrix();
  println(height);
  translate(10, height-100, 0);
  
  int widthBlock = 50;
  int y = 500;
  int hauteur = 30;
  for(int i = 0 ; i < historique.length; i++) {
    String[] pile = historique[i];
    
    for(int j = 0 ; j < pile.length; j++) {
      fill(255, 255, 255);
      stroke(0);
      rect(0, 0, widthBlock, hauteur);

      fill(0); // définit la couleur de remplissage à noir pour le texte
      textAlign(CENTER, CENTER); // centre le texte dans la boîte
      text(pile[j], widthBlock/2, hauteur/2); // affiche le texte dans la boîte
    }
  }
  popMatrix();
  // ======================
}

void keyPressed() {  
}
