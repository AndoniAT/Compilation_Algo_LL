/**
  Andoni ALONSO TORT
  UNIVERSITÉ DU HAVRE NORMANDIE
  M1 IWOCS INFORMATIQUE
  COMPILATION
*/
ArrayList<ArrayList<String>> tab;
ArrayList<ArrayList<String>> gramaire;
ArrayList<ArrayList<String>> code;
ArrayList<ArrayList<String>> codeWork;

int initX = 0;

ArrayList<ArrayList<String>> historique;

ArrayList<String> lastPile;

int idxLineCodeWork = 0;
int idxColCodeWork = 0;

String lastElementInTable;
int actualColonneInTable;

String regleSet = "0";
void setup() {
  size(1000, 800, P3D);
  surface.setTitle("Hello World!");
  surface.setResizable(true);
   historique = new ArrayList<ArrayList<String>>();
   
   lastPile = new ArrayList<String>();
   lastPile.add("$"); // First Element dans la pile
   historique.add(lastPile);
   
  // Lecture de la gramaire
  gramaire = readTableFile("gramaire.txt");

  // Lecture du tableau
  tab = readTableFile("tableauGramaire.txt");
  
  // Lecture de l'entree
  code = readTableFile("entree.txt");
  codeWork = new ArrayList<ArrayList<String>>(code);
  
  // Faire evoluer pour commencer
  faireEvoluerHistoriuque();
}

/**
  Methode pur lire un fichier et le retourner dans un tableau de deux dimensions
*/
ArrayList<ArrayList<String>> readTableFile(String src) {
  ArrayList<ArrayList<String>> table = new ArrayList<ArrayList<String>>();
  ArrayList<String> lignes = new ArrayList<String>(changeToList( (String[]) loadStrings(src)));
  
  
  for(int i = 0 ; i < lignes.size() ; i++) {
    ArrayList<String> parties = new ArrayList<String>(changeToList(split(lignes.get(i), ' ')));
    table.add(parties);
  }
  
  //println(table.toString());
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
    for(int i = 0 ; i < code.size(); i++) {
      for(int j = 0 ; j < code.get(i).size(); j++) {
        pushMatrix();
          translate(xEntreInit,30, 0);
        if(i == idxLineCodeWork && j == idxColCodeWork) {
          fill(orange);
        } else {
          fill(0);
        }
        //s += code[i][j] + " ";
        text(code.get(i).get(j), xEntreInit, 0);
        xEntreInit+= (code.get(i).get(j).length() * 5) + 10;
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
    rect(0, 0, tab.size()*35, (gramaire.size()*32));  // Dessine le carré
    
    // Table
    float yLigne = 15;
    
    int ligneRegle = 0;
    int colRegle = 0;
    for(int i = 0 ; i < tab.size() ; i++) {
      float xCol = 28;
      for(int j = 0 ; j < tab.get(i).size() ; j++) {
        color colorElement = color(0);
        int sizeTxt = 15;
        
        // Si on est dans la premier ligne verifier dans quelle colonne onse trouve actuellement
        if(i == 0 ) {
          //println("check equalite");
          //println(tab[i][j] + " == " + code[idxLineCodeWork][idxColCodeWork] + " => " + tab[i][j].equals(code[idxLineCodeWork][idxColCodeWork]));
          if(tab.get(i).get(j).equals(code.get(idxLineCodeWork).get(idxColCodeWork))) {
            colorElement = orange;
            sizeTxt = 17;
            colRegle = j; // On établi la colone de la regle que l'on va utiliser
          }
        }
        
        // Si on est dans la premier colonne verifier le dernier element qu'il y a dans la pile
        if(j == 0) {
          if(tab.get(i).get(j).equals(lastElementInTable)) {
            textSize(17);
            fill(104, 210, 101);
            sizeTxt = 17;
            colorElement = vert;
            ligneRegle = i; // On etabli la ligne de la regle que l'on va utiliser
            
          }
        }
        if(ligneRegle>0 && colRegle > 0) {
          regleSet = tab.get(ligneRegle).get(colRegle);
        }
        
        // colorer la regle actuel
        if(i > 0 && i == ligneRegle && j > 0 && j == colRegle) colorElement = bleu;
        
        fill(colorElement);
        textSize(sizeTxt);
        text(tab.get(i).get(j), xCol, yLigne);
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
    rect(0, 0, 200, (gramaire.size()*20) + 40);  // Dessine le carré
    
    // Gramaire texte
    float initY = 10;
    fill(255);
    textSize(30);
    text(" GRAMAIRE : ", 100, initY);
    textSize(15);
    initY+=40;
    textAlign(LEFT);
    for(int i = 0 ; i < gramaire.size(); i++) {
        color coloGram = color(255);
        String gram = "("+int(i+1)+") ";
        
        for(int j = 0 ; j < gramaire.get(i).size(); j++) {
          
           gram+= gramaire.get(i).get(j) != null ? gramaire.get(i).get(j).equals(":") ? " => " : gramaire.get(i).get(j) + " " : "";
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
    ArrayList<String> pile = historique.get(i);
    
    int hauteur = 30;
    for(int j = 0 ; j < pile.size(); j++) {
      if(i == historique.size()-1 && j == pile.size() -1) {
        fill(vert);
      } else {
        fill(255, 255, 255);
      }
      
      stroke(0);
      rect(xHistorique, 0, widthBlock, hauteur);

      fill(0); // définit la couleur de remplissage à noir pour le texte
      textAlign(CENTER, CENTER); // centre le texte dans la boîte
      text(pile.get(j), xHistorique+widthBlock/2, hauteur-hauteur/2); // affiche le texte dans la boîte
      hauteur -= 60 ; 
    }
    xHistorique+=widthBlock+10;
  }
  popMatrix();
  // ======================
}

void keyPressed() {  
  if(keyCode == LEFT) {
    popHistorique();
  }
  
  if(keyCode == RIGHT) {
    faireEvoluerHistoriuque();
  }
  
  println(keyCode);
}

void popHistorique() {

}

void faireEvoluerHistoriuque(){
  println("Faire evoluer");
  println("next character to analyze => " + codeWork.get(0).get(0));
  
  ArrayList<String> last = getLastPile();
  println("Last Pile : " + last.toString());
  
  if(last.size() == 1 && codeWork.size() > 0) {
    println("Start, ajouter => " + gramaire.get(0).get(0));
    createNewPile(changeToList( new String[] {  gramaire.get(0).get(0) } ), false );
  }
  
  /*lastElementInTable = last[last.length-1];
  println("LastElement => " + lastElementInTable);
  int regle = 0;
  if(regleSet.equals("pop")) {
    // pop in pile
  } else {
    regle = int(regleSet);
    
    // Obtenir le texte de la regle puor remplacer
    String regleTxt = "";
    String[] regleArray = new String[gramaire[regle-1].length-2];
    
    for(int col = 2, i = 0; col< gramaire[regle-1].length;col++, i++){
      regleTxt+=gramaire[regle-1][col] + " ";
      regleArray[i] = gramaire[regle-1][col]; 
    }
    
    println("Regle Index => " + regle);
    println("Remplacer '" + lastElementInTable + "' par => ' "+ regleTxt + " '");
    println("Regle Array");
    for(int i = 0 ; i < regleArray.length ; i++ ) {
      println(regleArray[i]);
    }
    createNewPile(regleArray);
  }*/
  
  
  /*for(int i = 0 ; i < last.length ; i++) {
    
    
  }*/
  
  
}

void createNewPile(ArrayList<String> s, boolean replace) {
  println("Create new PIle");
  
  println("S parameters =>" + s.toString());
  
  ArrayList<String> lastHistory = new ArrayList<String>(getLastPile());
  
  // S'il faut remplacer on va faire un pop
  println("Last history => " + lastHistory.toString());
  if(replace) {
    println("Replace, donc suppression dernier element => " + lastHistory.toString());
    lastHistory.remove(lastHistory.size()-1);
  } else {
    println("Ne pas remplacer");
  }
  
  // Creer nouvelle pile
  ArrayList<String> newPile = new ArrayList<>();
  newPile.addAll(lastHistory);
  newPile.addAll(s);
  
  println("NEW PILE => " + newPile);
  
  // Mettre a jour le dernier element dans la table
  lastElementInTable = newPile.get(newPile.size()-1);
  // =================================
  historique.add(newPile);
}

ArrayList<String> getLastPile() {
  return historique.get(historique.size()-1);
}

void afficherTable(String[] t) {
  String s = "";
  for(int i=0; i < t.length; i++) s +=t[i] + " | ";
  println(s);
}

ArrayList<String> changeToList(String[] tab) {
  ArrayList<String> newList = new ArrayList<String>();
  for(int i = 0 ; i < tab.length ; i++) newList.add(tab[i]);
  return newList;
}
