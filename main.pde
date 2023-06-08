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
ArrayList<String> codeDeleted = new ArrayList<String>();

int initX = 0;

ArrayList<ArrayList<String>> historique;

ArrayList<String> lastPile;

int idxLineCodeWork = 0;
int idxColCodeWork = 0;

String lastElementInTable;
int actualColonneInTable;

String regleSet = "0";
void setup() {
  size(1200, 800, P3D);
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
  codeWork = new ArrayList<ArrayList<String>>();
  
  // Recopie Lists
  for (ArrayList<String> list : code) codeWork.add(new ArrayList<>(list)); 
  
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
    ArrayList<String> parties = new ArrayList<String>();
    String[] parts = split(lignes.get(i), ' ');

    for(int j = 0 ; j < parts.length ; j++) {
      String mot = parts[j];
      if(!mot.equals("") && !mot.equals(" ")) parties.add(mot);
    }
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
  color rouge = color(159, 8, 8);
  color grise = color(128, 128, 128);
  
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
    // Deleted
    for(int i = 0 ; i < codeDeleted.size(); i++) {
        pushMatrix();
        translate(xEntreInit,30, 0);
        fill(grise);
        //s += code[i][j] + " ";
        text(codeDeleted.get(i), xEntreInit, 0);
        xEntreInit+= (codeDeleted.get(i).length() * 5) + 10;
        popMatrix();
    }

    //println("line => " + idxLineCodeWork);
    //println("col => " + idxColCodeWork);
    //println("codeWork => " + codeWork.toString());
    for(int i = 0 ; i < codeWork.size(); i++) {
      for(int j = 0 ; j < codeWork.get(i).size(); j++) {
        pushMatrix();
          translate(xEntreInit,30, 0);
        if(i == idxLineCodeWork && j == idxColCodeWork) {
          fill(orange);
        } else if(i <= idxLineCodeWork && j < idxColCodeWork){
          fill(grise);
        } else {
          fill(0);
        }
        
        
        //s += code[i][j] + " ";
        text(codeWork.get(i).get(j), xEntreInit, 0);
        xEntreInit+= (codeWork.get(i).get(j).length() * 5) + 10;
        popMatrix();
      }
    }
    textSize(15);
    xEntreInit = 20;
    for(int i = 0 ; i < codeWork.size(); i++) {
      for(int j = 0 ; j < codeWork.get(i).size(); j++) {
        pushMatrix();
        translate(xEntreInit,-10, 0);
        text(codeWork.get(i).get(j), 0, 0);
        xEntreInit+= (codeWork.get(i).get(j).length()) + 15;
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
          String motCode = codeWork.get(idxLineCodeWork).get(idxColCodeWork);
          boolean validate = false;
          String sel = validateMot(motCode);
          
          if(tab.get(i).get(j).equals(sel)) validate = true; 
          
          // Check orange dans la premier ligne (correspond au mot suivant dans notre entree)
          if(tab.get(i).get(j).equals(motCode) || validate) {
            colorElement = orange;
            sizeTxt = 17;
            colRegle = j; // On établi la colone de la regle que l'on va utiliser
          }
        }
        
        // Si on est dans la premier colonne verifier le dernier element qu'il y a dans la pile
        if(j == 0) {
          if(tab.get(i).get(j).equals(lastElementInTable)) {
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
      pushMatrix();
        translate(0, hauteur, 0);
      if(i == historique.size()-1 && j == pile.size() -1) {
        fill(vert);
      } else {
        fill(255, 255, 255);
      }
      
      stroke(0);
      rect(xHistorique, 0, widthBlock, 30);

      fill(0); // définit la couleur de remplissage à noir pour le texte
      textAlign(CENTER, CENTER); // centre le texte dans la boîte
      text(pile.get(j), xHistorique+widthBlock/2, 15); // affiche le texte dans la boîte
      
      hauteur -= 30 ;
      popMatrix();
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
  
  //println(keyCode);
}

void popHistorique() {
  //println("checking code deleted => " + codeDeleted.toString());
  ArrayList<String> lastDelete = historique.remove(historique.size()-1); // Supprimer le dernier historique
  println("Delete in historique => " + lastDelete.toString());
  
  ArrayList<String> lastHistorique = historique.get(historique.size()-1); // Obtenir le dernier historique après la suppresion
  String lastElementHistorique = lastHistorique.get(lastHistorique.size()-1); // Obtenir le dernier elelment du dernier historique
  // S'il y a encore des elements qui ont ete supprimes
  if( codeDeleted.size() > 0 ){
    
    String lastElementInCodeDeleted = codeDeleted.get(codeDeleted.size()-1); // Obtenir le dernier element du code qui a ete supprime
    boolean validated = false;
    
    String sel = validateMot(lastElementInCodeDeleted);
    println("Validate mot => " + lastElementInCodeDeleted);
    println(sel);
    if(lastElementHistorique.equals(sel)) validated = true;
          
    // Comparer s'ils sont pareils, on peut recuperer l'element du code pour le reintegrer
    if(lastElementHistorique.equals(lastElementInCodeDeleted) || validated) {
      println("Reintegrer to =>" + codeWork.toString());
      codeWork.get(0).add(0, new String(codeDeleted.remove(codeDeleted.size()-1)));
      //println("Reintegrated =>" + codeWork.toString());
      /*println("Line => "+  idxLineCodeWork);
      println("Col => "+  idxColCodeWork);*/
      idxColCodeWork -= idxColCodeWork > 0 ? 1 : 0;
      idxLineCodeWork -= idxColCodeWork == 0 && idxLineCodeWork > 0 ? 1 : 0 ;
    }
    
  }
  

 
  mettreAjourVariables();
  println("Line => "+  idxLineCodeWork);
  println("Col => "+  idxColCodeWork);
  println("CodeWork to =>" + codeWork.toString());
}

void faireEvoluerHistoriuque(){
  //println("Faire evoluer");
  //println("next character to analyze => " + codeWork.get(0).get(0));
  
  ArrayList<String> last = getLastPile();
  //println("Last Pile : " + last.toString());
  
  if(last.size() == 1 && codeWork.size() > 0) {
    //println("Start, ajouter => " + gramaire.get(0).get(0));
    createNewPile(changeToList( new String[] {  gramaire.get(0).get(0) } ), false );
    return;
  }
  
  // Continuer de faire evoluer la pile
  //println("Continuer a faire evoluer");
  int regle = 0;
  
  //println("regle actuelle => " + regleSet);
  if(last.get(last.size()-1).equals("eps")) {
    // pop in pile
    ArrayList<String> vide = new ArrayList<String>();
    createNewPile(vide, true);
    return;
  }
  
  if(regleSet.equals("pop")) {
    
    if(codeWork.get(0).size() > 0) { // Si la premier ligne est vide, la suppriemr
      //println("remove element => " + codeWork.toString());
      // Sinon supprimer le mot prochain
      codeDeleted.add(new String(codeWork.get(0).remove(0)));
      //println("apres element => " + codeWork.toString());
      //idxColCodeWork++; // Augmenter la ligne
    } 
    
    if(codeWork.get(0).size() == 0) { // Si la premier ligne est vide, la suppriemr
      //println("remove ligne");
      codeWork.remove(0);
      
      // Index for code
      //idxLineCodeWork++; // La ligne augmente
      idxColCodeWork = 0; // La colonne recommence a 0
    }
    
    // pop in pile
    ArrayList<String> vide = new ArrayList<String>();
    createNewPile(vide, true);
    
  } else {
    regle = int(regleSet);
    
    // Obtenir le texte de la regle puor remplacer
    ArrayList<String> regleArray = new ArrayList<String>(gramaire.get(regle-1));
    regleArray.remove(0);regleArray.remove(0); // Supprimer deux premieres colonnes => "clé" et separation ":"
    //println("Ajouter a la pile => " + regleArray.toString());
    regleArray = inverserArray(regleArray); // Inverser
    createNewPile(regleArray, true);
  }
}

void createNewPile(ArrayList<String> s, boolean replace) {
  //println("Create new PIle");
  
  //println("S parameters =>" + s.toString());
  
  ArrayList<String> lastHistory = new ArrayList<String>(getLastPile());
  
  // S'il faut remplacer on va faire un pop
  //println("Last history => " + lastHistory.toString());
  if(replace) {
    //println("Replace, donc suppression dernier element => " + lastHistory.toString());
    lastHistory.remove(lastHistory.size()-1);
  } else {
    //println("Ne pas remplacer");
  }
  
  // Creer nouvelle pile
  ArrayList<String> newPile = new ArrayList<>();
  newPile.addAll(lastHistory);
  newPile.addAll(s);
  // =================================
  historique.add(newPile);
  
  // Mettre variables a jour
  mettreAjourVariables();
}

void mettreAjourVariables() {
  // Mettre a jour le dernier element dans la table
  ArrayList<String> lastPile = getLastPile();
  lastElementInTable = lastPile.get(lastPile.size()-1);
  
}

ArrayList<String> getLastPile() {
  return historique.get(historique.size()-1);
}

void afficherTable(String[] t) {
  String s = "";
  for(int i=0; i < t.length; i++) s +=t[i] + " | ";
  //println(s);
}

ArrayList<String> changeToList(String[] tab) {
  ArrayList<String> newList = new ArrayList<String>();
  for(int i = 0 ; i < tab.length ; i++) newList.add(tab[i]);
  return newList;
}

ArrayList<String> inverserArray(ArrayList<String> list) {
  ArrayList<String> newList = new ArrayList<String>();
  for(int i = list.size()-1 ; i >=0 ; i--) newList.add(list.get(i));
  return newList;
}

String validateMot(String motCode){
  String value = "";
  ArrayList<String> lang = new ArrayList<>(tab.get(0));
  lang.remove(lang.indexOf("id"));
  lang.remove(lang.indexOf("nb"));  
          
  int indexMot = lang.indexOf(motCode);
          
  if(indexMot == -1) {
     // Si c'est pas un nombre alors c'est un id
     if(Float.isNaN(float(motCode))) {
      value = "id";
     //validate = (tab.get(i).get(j).equals("id")) ? true : validate;
  } else {
      // C'est un nombre
      value = "nb";
     //validate = (tab.get(i).get(j).equals("nb")) ? true : validate;
     }
  }
  return value;
}
