/**
  Andoni ALONSO TORT
  UNIVERSITÉ DU HAVRE NORMANDIE
  M1 IWOCS INFORMATIQUE
  COMPILATION
*/

// ArrayList des elements
ArrayList<ArrayList<String>> historique;     // Sauvegarde toutes les evolutions de la pile
ArrayList<ArrayList<String>> tab;           // Le tableau de la grammaire
ArrayList<ArrayList<String>> gramaire;      // La gramaire
ArrayList<ArrayList<String>> codeWork;      // L'entree que l'on va analyser
ArrayList<String> codeDeleted;

int initX;
int idxLineCodeWork; // Ligne dans le code d'entree que l'on se trouve
int idxColCodeWork;  // Colonne dans le code d'entree que l'on se trouve
String regleSet; // Regle set par defaut 0

int transX, xActual, limitewidth;

boolean init = false;

ArrayList<ArrayList<ArrayList<String>>> choixMots = new ArrayList<>();
int actualChoice = -1;
int choiseMoving = -1;
void setup() {
  size(1200, 800, P3D);
  surface.setTitle("Hello World!");
  surface.setResizable(true);
  
  // Lecture de la gramaire
  gramaire = readTableFile("gramaire.txt");

  // Lecture du tableau
  tab = readTableFile("tableauGramaire.txt");
  
  // Lecture de l'entree
  fichiersLecture();
  // Faire evoluer pour commencer
  //faireEvoluerHistoriuque();
}

void initVariables() {
  initX = 0;
  idxLineCodeWork = 0; // Ligne dans le code d'entree que l'on se trouve
  idxColCodeWork = 0;  // Colonne dans le code d'entree que l'on se trouve
  regleSet = "0"; // Regle set par defaut 0
  transX = 0;
  xActual = 0;
  limitewidth = width;
  
  codeDeleted = new ArrayList<String>();
  codeWork = new ArrayList<ArrayList<String>>();
  historique = new ArrayList<ArrayList<String>>();
  ArrayList<String> initPile = new ArrayList<String>();
  initPile.add("$"); // First Element dans la pile
  historique.add(initPile);
}

void fichiersLecture() {
  ArrayList<ArrayList<String>> choix = readTableFile("entree.txt");
  choixMots.add(choix);
}

/**
  Methode pur lire un fichier et le retourner dans un tableau de deux dimensions
  @var path : chemin du fichier que l'on veut lire 
  @return un ArrayList de deux dimensions contenant le contenu du fichier lu
*/
ArrayList<ArrayList<String>> readTableFile(String path) {
  ArrayList<ArrayList<String>> table = new ArrayList<ArrayList<String>>();
  ArrayList<String> lignes = new ArrayList<String>(changeToList( (String[]) loadStrings(path)));
  
  for(int i = 0 ; i < lignes.size() ; i++) {
    ArrayList<String> parties = new ArrayList<String>();
    String[] parts = split(lignes.get(i), ' ');

    for(int j = 0 ; j < parts.length ; j++) {
      String mot = parts[j];
      if(!mot.equals("") && !mot.equals(" ")) parties.add(mot);
    }
    table.add(parties);
  }
  
  return table;
}

void draw() {
  background(200);
  
  switch(actualChoice) {
    case -1: {
      init = false;
      dessinerChoisir();
      break;
    }
    default: {
      if(!init) {
        initVariables();
        init = true;
      }
      pushMatrix();
        int x  = 20; int y = 10;
        int widthRect = 90; int heigthRect = 25;
        translate(x, 10, 0);
        boolean verif = verifMouse(x, x+widthRect, y, y+heigthRect);
        color c = color(0,0,0,100);
        
        if(verif) {
          c = color(0,0,0,50);
          choiseMoving = -1;
        }
        
        fill(c);
        
        rect(0,0,widthRect,heigthRect);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(15);
        text("Retourner", widthRect/2, heigthRect/2);
        
      popMatrix();
      // Recopier code d'entre
      if(codeWork.size()==0) {
       ArrayList<ArrayList<String>> codeObject = choixMots.get(actualChoice);
       for(int i = 0 ; i < codeObject.size() ; i++) {
         if(i == codeWork.size()) codeWork.add(new ArrayList<String>(codeObject.get(i)));
       }
       
      }
      print("mon object");
      print(codeWork);
      print("\n");
      dessinerMot();  
    }
  }
  
  
}

void dessinerChoisir() {
  background(255);
  pushMatrix();
    translate(width/2,65,0);
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(0,0,0,180);
    String s = " Andoni ALONSO TORT \n UNIVERSITE DU HAVRE \n Projet Compilation 2023 \n MASTER IWOCS Informatique";
    text(s,0,0); // affiche le texte dans la boîte
  popMatrix();

  textAlign(LEFT);
  textSize(20);
  pushMatrix();
    translate(50,160,0);
    text("Veuillez choisir un code à compiler",0,0); // affiche le texte dans la boîte
  popMatrix();
  
  int y = 220;
  int x = 50;
  for(int i = 0 ; i < choixMots.size(); i++ ) {
    ArrayList<ArrayList<String>> code = choixMots.get(i);
      pushMatrix();
        translate(x, y, 0);
        int calculY = 30+code.size()*25;
        boolean checkFill = verifMouse(x, x+300, y, y+(calculY));
        color fill = color(255);
        
        if(checkFill) {
          choiseMoving = i;
          fill = color(0,255,0, 40);
        } else {
          choiseMoving = -1;
        }
        
        fill(fill);
        stroke(0);
        rect(0, 0, 300, calculY);
        
        String txt = "Code " + int(i+1);
        fill(0);
        if(i == 0) {
          textSize(20);
          txt += ": Sans erreur";
          text(txt, 0, -20); // affiche le texte dans la boîte
        }
        
      int yChange = 45;
      for(int ligne = 0 ; ligne < code.size(); ligne++ ) {
        ArrayList<String> ligneCode = code.get(ligne);
        String ligneString = "";
        for(int col = 0 ; col < ligneCode.size(); col++ ) {
          String mot = ligneCode.get(col);
          ligneString+=mot + " ";
        }
        
        pushMatrix();
            int xTraslate = 60;
            if(ligne == 0 || ligne == code.size()-1) xTraslate = 40;
            translate(xTraslate, yChange, 0);
          
            //String charac = code.get(ligne).get(col);
            fill(0); // définit la couleur de remplissage à noir pour le texte
            //textAlign(CENTER, CENTER); // centre le texte dans la boîte  
            text(ligneString, 0, 0); // affiche le texte dans la boîte
        popMatrix();
        yChange+=20;
      }
      
      popMatrix();
  }
       
}

boolean verifMouse(int initX, int finX, int initY, int finY) {
  boolean verif = false;
  print("mouse X =>" + mouseX + "\n");
  print("mouse X =>" + mouseY + "\n");
  cursor(ARROW);
  if(mouseX >= initX && mouseX <= finX && mouseY >= initY && mouseY <= finY ) {
    cursor(HAND);
    verif = true;
  }
 return verif;
}

void mouseClicked() {
  actualChoice = choiseMoving;
}

void dessinerMot() {
  if(getLastPile().size() ==0 ) return;
  
  if(xActual > limitewidth - 60 ) {
    transX-=70;
    limitewidth = xActual + 60;
  } else if (limitewidth > width && limitewidth > xActual + 60){
    limitewidth-=60;
    transX+=70;
  }
  
  translate(transX, 0);
  
  // == DEFINITION DE COULEURS ==
  color orange = color(218,177,81);
  color vert = color(104, 210, 101);
  color bleu = color(104, 100, 255);
  color rouge = color(159, 8, 8);
  color grise = color(128, 128, 128);
  
  //  == Afficher l'entree ==
  pushMatrix();
    // Carré conteneur    
    translate(20-transX,30, 0);
    fill(0); // définit la couleur de remplissage à noir pour le texte
    textSize(40);
    textAlign(CENTER, CENTER); // centre le texte dans la boîte
    String s = "";
    int xEntreInit = 20;
    
    // Afficher la partie du code qui a déjà été supprimé
    for(int i = 0 ; i < codeDeleted.size(); i++) {
        pushMatrix();
        translate(xEntreInit,30, 0);
        fill(grise);
        //s += code[i][j] + " ";
        text(codeDeleted.get(i), xEntreInit, 0);
        xEntreInit+= (codeDeleted.get(i).length() * 5) + 10;
        popMatrix();
    }

    // Afficher le code qui nous reste a traiter
    for(int ligne = 0, setColor = orange; ligne < codeWork.size(); ligne++) {
      for(int col = 0 ; col < codeWork.get(ligne).size(); col++, setColor = 0) {
        pushMatrix();
          translate(xEntreInit,30, 0);
          fill(setColor); // Pour la premiere ligne et la premiere colonne la couleur sera orange, pour les autres, noir
          text(codeWork.get(ligne).get(col), xEntreInit, 0);
          xEntreInit+= (codeWork.get(ligne).get(col).length() * 5) + 10; // Avancer x
        popMatrix();
      }
    }
    textSize(15);
  // =======================
  popMatrix();
  
  // == Afficher TABLE ==
  pushMatrix();
    translate(250-transX, 100, 0); 
    noFill();
    fill(255);
    stroke(255);
    rect(0, 0, tab.size()*35, (gramaire.size()*32));  // Dessine le carré
    
    // Table
    float yLigne = 15;
    int ligneRegle = 0;
    int colRegle = 0;
    
    for(int ligne = 0 ; ligne < tab.size() ; ligne++) {
      float xCol = 28;
      for(int col = 0 ; col < tab.get(ligne).size() ; col++) {
        color colorElement = color(0);
        int sizeTxt = 15;
        
        // Si on est dans la premier ligne verifier dans quelle colonne on se trouve actuellement
        if(ligne == 0 ) {
          String mot = codeWork.size() > 0 ? codeWork.get(0).get(0) : "";
          String resValidateMot = validateMot(mot); // Retourne si le mot est "id" ou "nb" sinon, il retourne la valeur du mot
          
          // Check orange dans la premier ligne le mot qui correspond au mot suivant dans notre entree
          if(tab.get(ligne).get(col).equals(resValidateMot)) {
            colorElement = orange;
            sizeTxt = 20;
            colRegle = col; // On établi la colone de la regle que l'on va utiliser
          }
        }
        
        // Check vert dans la premier colonne l'element qui correspond au prochain element à traiter dans la pile 
        if(col == 0) {
          if(tab.get(ligne).get(col).equals(getLastElementInTable())) {
            sizeTxt = 20;
            colorElement = vert;
            ligneRegle = ligne; // On etabli la ligne de la regle que l'on va utiliser
          }
        }
        // Une fois aue nous savon la colonne et la ligne a traiter, nous pouvons établir la régle :
        if(ligneRegle > 0 && colRegle > 0) {
          //print("setting");
          regleSet = tab.get(ligneRegle).get(colRegle);
          //print("setting refle finish");
        }
        
        // colorer la regle actuel
        if(ligne > 0 && ligne == ligneRegle && col > 0 && col == colRegle) { 
          colorElement = bleu;
          sizeTxt = 20;
        }
        
        fill(colorElement);
        textSize(sizeTxt);
        text(tab.get(ligne).get(col), xCol, yLigne);
        xCol+=60;
      }
      yLigne+=20;
      
    }
    
    for( int i = 0 ; i < tab.size(); i++ ) {
      for( int j = 0 ; j < tab.size(); j++ ) {
         
      }
    }
  
  popMatrix();
  // ======================
  
  
  // ==== GRAMAIRE =========
  pushMatrix();
    // Carré conteneur
    int X0 = 20;
    translate(X0-transX, 100, 0); 
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
    
    for(int ligne = 0 ; ligne < gramaire.size(); ligne++) {
        color coloGram = color(255);
        String gram = "("+int(ligne+1)+") ";
        
        for(int col = 0 ; col < gramaire.get(ligne).size(); col++) {
           gram+= gramaire.get(ligne).get(col) != null ? gramaire.get(ligne).get(col).equals(":") ? " => " : gramaire.get(ligne).get(col) + " " : "";
        }
        
        int numGram = ligne + 1;
        if(regleSet.equals(numGram+"")) { 
          coloGram = bleu;
          textSize(20);
        } else {
          textSize(15);
        }
        
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
  int xHistorique = 0;
  for(int ligne = 0 ; ligne < historique.size(); ligne++) {
    ArrayList<String> pile = historique.get(ligne);
    int hauteur = 30;
    
    for(int col = 0; col < pile.size(); col++) {
      pushMatrix();
        translate(0, hauteur, 0);
    
      color colorFill = color(239, 69, 222, 100 );
      if(ligne == historique.size()-1 && col == pile.size() -1) {
        colorFill = vert;
      } else if (col==0) {
        colorFill = color(255);
      }else if(col % 2 == 0){
        colorFill = color(239, 69, 222, 150 );
      }
      
      fill(colorFill);
      stroke(0);
      rect(xHistorique, 0, widthBlock, 30);

      fill(0); // définit la couleur de remplissage à noir pour le texte
      textAlign(CENTER, CENTER); // centre le texte dans la boîte
      text(pile.get(col), xHistorique+widthBlock/2, 15); // affiche le texte dans la boîte
      
      hauteur -= 30 ;
      popMatrix();
    }
    xHistorique+=widthBlock+10;
    xActual = xHistorique; 
  }
  popMatrix();
  // ======================
}

void keyPressed() {  
  if(actualChoice >= 0) {
    if(keyCode == LEFT) {
      popHistorique();
    }
  
    if(keyCode == RIGHT) {
      faireEvoluerHistoriuque();
    }
  }
}

/**
  Methode pour supprimer un element de l'historique => revenir en arriere
*/
void popHistorique() {
  if(historique.size() == 1) return;
  ArrayList<String> lastDelete = historique.remove(historique.size()-1); // Supprimer le dernier historique
  ArrayList<String> lastHistorique = historique.get(historique.size()-1); // Obtenir le dernier historique après la suppresion
  String lastElementHistorique = lastHistorique.get(lastHistorique.size()-1); // Obtenir le dernier elelment du dernier historique
  
  // S'il y a encore des elements qui ont ete supprimes
  if( codeDeleted.size() > 0 ) {
    
    String lastElementInCodeDeleted = codeDeleted.get(codeDeleted.size()-1); // Obtenir le dernier element du code qui a ete supprime
    boolean validated = false;
    
    lastElementInCodeDeleted = validateMot(lastElementInCodeDeleted);
    
    // Comparer s'ils sont pareils, on peut recuperer l'element du code pour le reintegrer
    if(lastElementHistorique.equals(lastElementInCodeDeleted)) {
      //println("Reintegrer to =>" + codeWork.toString());
      if( codeWork.size() ==0 ) {
        ArrayList<String> listnew = new ArrayList<String>();
        codeWork.add(listnew);
      }
      codeWork.get(0).add(0, new String(codeDeleted.remove(codeDeleted.size()-1)));
      //println("Reintegrated =>" + codeWork.toString());
      /*println("Line => "+  idxLineCodeWork);
      println("Col => "+  idxColCodeWork);*/
      idxColCodeWork -= idxColCodeWork > 0 ? 1 : 0;
      idxLineCodeWork -= idxColCodeWork == 0 && idxLineCodeWork > 0 ? 1 : 0 ;
    }
    
  }
 
  //mettreAjourVariables();
  //println("Line => "+  idxLineCodeWork);
  //println("Col => "+  idxColCodeWork);
  //println("CodeWork to =>" + codeWork.toString());
}

/**
  Methode pour faire evoluer l'historique, on va ajouter la pile suivant en suivante les étapes necessaires
  1.- Verifier si se trouve au debut du programe, c'est a dire si la pile n'est qu'un element et si le code d'entré a toujours des mots à traiter
  2.- 
*/
void faireEvoluerHistoriuque(){
  //println("Faire evoluer");
  //println("next character to analyze => " + codeWork.get(0).get(0));
  
  ArrayList<String> last = getLastPile();
  //println("Last Pile : " + last.toString());
  
  // Verifier si on doit initialiser la pile
  if(last.size() == 1 && codeWork.size() > 0) {
    //println("Start, ajouter => " + gramaire.get(0).get(0));
    
    createNewPile(changeToList( new String[] {  gramaire.get(0).get(0) } ), false );
    return;
  }
  
  if(last.size() == 1 && codeWork.size() == 0) {
    return;
  }
  
  // Continuer de faire evoluer la pile
  //println("Continuer a faire evoluer");
  
  //println("regle actuelle => " + regleSet);
  if(last.get(last.size()-1).equals("eps")) {
    // pop in pile
    ArrayList<String> vide = new ArrayList<String>();
    createNewPile(vide, true);
    return;
  }
  
  // Si la regle actuel à faire est pop on va créer une nouvelle pille tout en supprimant l'element a traiter de la pile actuel
  switch(regleSet) {
    case "pop" : {

      if(codeWork.get(0).size() > 0) { // Si la premier ligne n'est pas vide
        codeDeleted.add(new String(codeWork.get(0).remove(0))); // Supprimer le prochain mot en l'ajoutant à notre liste du code qui a été supprimé
      } 
      
      // Si la premier ligne est vide, la suppriemr
      if(codeWork.get(0).size() == 0) { 
        codeWork.remove(0);
        idxColCodeWork = 0; // La colonne recommence a 0
      }
      
      // Pop in pile
      ArrayList<String> vide = new ArrayList<String>();
      createNewPile(vide, true);
      break;
    }
    default : {
      // C'est une regle dans la gramaire
       int regle = int(regleSet);
      
      // Obtenir le texte de la regle pour remplacer dans la pile
      ArrayList<String> regleArray = new ArrayList<String>(gramaire.get(regle-1));
      regleArray.remove(0); regleArray.remove(0); // Supprimer deux premieres colonnes => "clé" et separation ":"
      regleArray = inverserArray(regleArray); // Inverser
      
      // Ajouter la nouvelle regle dans la pile en remplaçant le dernier element à traiter
      createNewPile(regleArray, true);
    }
  }
}

/**
  Création d'une nouvelle pile par rapport aux parametres envoyés
  @var s : List que l'on souhaite ajouter à  la nouvelle pile
  @var replace : Pour savoir si on va garder ou pas le dernier element de la pile actuelle
  @return : La nouvelle pile => Ancien pile + listAdd
*/
void createNewPile(ArrayList<String> listAdd, boolean replace) {
  //println("Create new PIle");
  
  //println("S parameters =>" + s.toString());
  
  ArrayList<String> lastHistory = new ArrayList<String>(getLastPile());
  
  // S'il faut remplacer on va faire un pop
  //println("Last history => " + lastHistory.toString());
  if(replace) {
    //println("Replace, donc suppression dernier element => " + lastHistory.toString());
    lastHistory.remove(lastHistory.size()-1);
  }
  
  // Creer nouvelle pile
  ArrayList<String> newPile = new ArrayList<>();
  newPile.addAll(lastHistory);
  newPile.addAll(listAdd);
  // =================================
  historique.add(newPile);
  
  // Mettre variables a jour
  //mettreAjourVariables();
}

/*void mettreAjourVariables() {
  // Mettre a jour le dernier element dans la table
  ArrayList<String> lastPile = getLastPile();
  lastElementInTable = lastPile.get(lastPile.size()-1);
  
}*/

/**
  Methode pour obtenir le dernier element de la pile actuel
  @return l'element suivant dans la pile a traiter
*/
String getLastElementInTable() {
  //print("last element\n");
  // Mettre a jour le dernier element dans la table
  return getLastPile().get(getLastPile().size()-1);
}
/**
  Methode puor obtenir le ternier element de l'historique 
  @return  La pile actuelle
*/
ArrayList<String> getLastPile() {
  return historique.get(historique.size()-1);
}

/**
  Methode qui prend un tableau de string et le transforme en ArrayList
  @var tab : Le tableau de string qui nous interese transformer
  @return nouvel ArrayList
*/
ArrayList<String> changeToList(String[] tab) {
  ArrayList<String> newList = new ArrayList<String>();
  for(int i = 0 ; i < tab.length ; i++) newList.add(tab[i]);
  return newList;
}

/**
  Methode pour inverser un arraylist
  @var list : La liste qui nous interese inverser
  @return le même arrayList aves les valeurs inversés
*/
ArrayList<String> inverserArray(ArrayList<String> list) {
  ArrayList<String> newList = new ArrayList<String>();
  for(int i = list.size()-1 ; i >=0 ; i--) newList.add(list.get(i));
  return newList;
}

/**
  Valider si un mot es id et nb
  @var : la chaine de caracteres que l'on veut vérifier
  @return : id si la chaine peut corresponde à l'id d'une variable ou nb si elle peut correspondre à une chiffre
*/
String validateMot(String motCode){
  String value = motCode;
  ArrayList<String> lang = new ArrayList<>(tab.get(0)); // Les strings de notre langage
  
  // On enleve id et nb de la liste
  lang.remove(lang.indexOf("id"));
  lang.remove(lang.indexOf("nb"));  
          
  // Verifier si le mot se trouve dans la liste du langage
  int indexMot = lang.indexOf(motCode);
  if(indexMot == -1) {
     // S'il est pas dans la liste alors on vérifie si c'est un nombre
     // Si c'est pas un nombre alors la valeur peuit correspondre à un id
     value = Float.isNaN(float(motCode)) ? "id" : "nb";
  }
  return value;
}
