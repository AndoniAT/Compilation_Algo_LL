/**
  Andoni ALONSO TORT
  UNIVERSITÉ DU HAVRE NORMANDIE
  M1 IWOCS INFORMATIQUE
  COMPILATION
*/
String[][] tab = {};
String[][] gramaire = {};
String[][] code;
int initX = 0;
ArrayList<String[]> historique;
String[] lastPile;

int idxLineCodeWork = 0;
int idxColCodeWork = 0;

String lastElementInTable;
int actualColonneInTable;

String regleSet = "0";
void setup() {
  size(1000, 800, P3D);
  surface.setTitle("Hello World!");
  surface.setResizable(true);
   historique = new ArrayList<String[]>();
   String[] pileInit = {"$"};
   historique.add(pileInit);
   
  // Lecture de la gramaire
  gramaire = readTableFile("gramaire.txt");
  String[] fistEl =  { gramaire[0][0] };
  createNewPile(fistEl);
  lastElementInTable= fistEl[0];
  //historique.add();
  //println(gramaire[0]);
  
  // Lecture du tableau
  tab = readTableFile("tableauGramaire.txt");
  
  // Lecture de l'entree
  code = readTableFile("entree.txt");
  setActualColonneInTable();
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
  color orange = color(218,177,81);
  color vert = color(104, 210, 101);
  color bleu = color(104, 100, 255);
  //  == Afficher l'entree ==
  pushMatrix();
    // Carré conteneur
    //int X0 = 20;
    translate(20,30, 0);
    fill(0); // définit la couleur de remplissage à noir pour le texte
    textSize(40);
    textAlign(CENTER, CENTER); // centre le texte dans la boîte
    String s = "";
    int xEntreInit = 20;
    for(int i = 0 ; i < code.length; i++) {
      for(int j = 0 ; j < code[i].length; j++) {
        pushMatrix();
          translate(xEntreInit,30, 0);
        if(i == idxLineCodeWork && j == idxColCodeWork) {
          fill(orange);
        } else {
          fill(0);
        }
        //s += code[i][j] + " ";
        text(code[i][j], xEntreInit, 0);
        xEntreInit+= (code[i][j].length() * 5) + 10;
        popMatrix();
      }
    }
    
    textSize(15);
  // =======================
  popMatrix();
  
  // == TABLE ==
  pushMatrix();
    translate(250, 100, 0); 
    noFill();
    fill(255);
    stroke(255);
    rect(0, 0, tab.length*35, (gramaire.length*32));  // Dessine le carré
    
    // Table
    float yLigne = 15;
    
    int ligneRegle = 0;
    int colRegle = 0;
    for(int i = 0 ; i < tab.length ; i++) {
      float xCol = 28;
      for(int j = 0 ; j < tab[i].length ; j++) {
        color colorElement = color(0);
        int sizeTxt = 15;
        
        // Si on est dans la premier ligne verifier dans quelle colonne onse trouve actuellement
        if(i == 0 ) {
          //println("check equalite");
          //println(tab[i][j] + " == " + code[idxLineCodeWork][idxColCodeWork] + " => " + tab[i][j].equals(code[idxLineCodeWork][idxColCodeWork]));
          if(tab[i][j].equals(code[idxLineCodeWork][idxColCodeWork])) {
            colorElement = orange;
            sizeTxt = 17;
            colRegle = j; // On établi la colone de la regle que l'on va utiliser
          }
        }
        
        // Si on est dans la premier colonne verifier le dernier element qu'il y a dans la pile
        if(j == 0) {
          if(tab[i][j].equals(lastElementInTable)) {
            textSize(17);
            fill(104, 210, 101);
            sizeTxt = 17;
            colorElement = vert;
            ligneRegle = i; // On etabli la ligne de la regle que l'on va utiliser
            
          }
        }
        if(ligneRegle>0 && colRegle > 0) {
          regleSet = tab[ligneRegle][colRegle];
        }
        
        // colorer la regle actuel
        if(i > 0 && i == ligneRegle && j > 0 && j == colRegle) colorElement = bleu;
        
        fill(colorElement);
        textSize(sizeTxt);
        text(tab[i][j], xCol, yLigne);
        xCol+=60;
      }
      yLigne+=20;
      
    }
  
  popMatrix();
  // ======================
  
  
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
        color coloGram = color(255);
        String gram = "("+int(i+1)+") ";
        
        for(int j = 0 ; j < gramaire[i].length; j++) {
          
           gram+= gramaire[i][j] != null ? gramaire[i][j].equals(":") ? " => " : gramaire[i][j] + " " : "";
        }
        int numGram = i + 1;
        if(regleSet.equals(numGram+"")) coloGram = bleu;
        
        // Definir la couleur de remplissage à noir pour le texte
        fill(coloGram); 
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
  
  // == PILE HISTORIQUE =======
  pushMatrix();
  //println(height);
  translate(10, height-100, 0);
  
  int widthBlock = 50;
  int y = 500;
  int xHistorique = 0;
  for(int i = 0 ; i < historique.size(); i++) {
    String[] pile = historique.get(i);
    
    int hauteur = 30;
    for(int j = 0 ; j < pile.length; j++) {
      if(i == historique.size()-1 && j == pile.length -1) {
        fill(vert);
      } else {
        fill(255, 255, 255);
      }
      
      stroke(0);
      rect(xHistorique, 0, widthBlock, hauteur);

      fill(0); // définit la couleur de remplissage à noir pour le texte
      textAlign(CENTER, CENTER); // centre le texte dans la boîte
      text(pile[j], xHistorique+widthBlock/2, hauteur-hauteur/2); // affiche le texte dans la boîte
      hauteur -= 60 ; 
    }
    xHistorique+=widthBlock+10;
  }
  popMatrix();
  // ======================
}

void keyPressed() {
  println("pressed");
  println(key);
  
  if(keyCode == LEFT) {
    println("left");
    popHistorique();
  }
  
  if(keyCode == RIGHT) {
    println("rigth");
    faireEvoluerHistoriuque();
  }
  println(keyCode);
}

void popHistorique() {

}

void faireEvoluerHistoriuque(){
  println("Faire evoluer");
  //println("next character to analyze => " + code[idxLineCodeWork][idxColCodeWork]);
  //println("Last Pile");
  String[] last = getLastPile();
  lastElementInTable = last[last.length-1];
  //println("LastElement => " + lastElementInTable);
  /*for(int i = 0 ; i < last.length ; i++) {
    
    
  }*/
  
  
}

void createNewPile(String[] s) {
  String[] lastHistory = historique.get(historique.size()-1);
  lastPile = new String[lastHistory.length + s.length];
  
  String[] newPile = new String[lastHistory.length + 1];  
  
  for(int i = 0 ; i < lastHistory.length ; i++ ) {
    newPile[i] = lastHistory[i];
  }
  
  for(int idx = lastHistory.length, i = 0; i < s.length ; i++ ) {
    newPile[idx] = s[i];
  }
  historique.add(newPile);
}

String[] getLastPile() {
  return historique.get(historique.size()-1);
}

void setActualColonneInTable() {
  String wordToTrait = code[idxLineCodeWork][idxColCodeWork];
  println("set actualColonne");
  //println(wordToTrait);
  
}
