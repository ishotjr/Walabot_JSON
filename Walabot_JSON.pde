JSONArray JSONArray;
int time;

void setup() {
  
    time = 0;
    size(1920, 1280);
    
    background(0);  
    noStroke(); 
    
    // reduce color range vs. multiplying later
    colorMode(RGB,10,10,10,255);
    
}

void loadJSONData() {
 
    String[] json = loadStrings("http://192.168.1.69:5000/walabot/api/v1.0/sensortargets");
    for(String s: json){
       println(s);
    }
  
    saveStrings("data.json", json);
  
    JSONObject jobj =  loadJSONObject("data.json");
    
    JSONArray = jobj.getJSONArray("sensortargets");
     
}

void draw() {
  
  // in order to not DOS the server!
  if (millis() > time) {
    
    time = time + 3000;
    loadJSONData();
    
    for(int i = 0 ; i < JSONArray.size() ; i++){
      
       JSONObject eventObject = JSONArray.getJSONObject(i);
       
       if (i % 3 == 0) {
         fill(eventObject.getFloat("amplitude") * 1000,0,0);
       } else if (i % 3 == 1) {
         fill(0,eventObject.getFloat("amplitude") * 1000,0);
       } else {
         fill(0,0,eventObject.getFloat("amplitude") * 1000);
       }
       
       // TODO: check for overflow/maybe rescale based on known range and canvas size?
       ellipse(abs(eventObject.getFloat("xPosCm")) * 10, 
               abs(eventObject.getFloat("yPosCm")) * 10, 
               abs(eventObject.getFloat("zPosCm")) * 10, 
               abs(eventObject.getFloat("zPosCm")) * 10);
               
    }
    
  }
  
}
