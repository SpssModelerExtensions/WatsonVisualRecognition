# Classify images with Watson Visual Recognition

This extension enables you harness the power of deep learning and automatically analyze the contents of pictures.

<p align="center">
  <img src="wvr.png"/ width=300px>
</p>

serice demo:
https://visual-recognition-demo.mybluemix.net/

# Before you start

1. Sign up an IBM Bluemix acount.

	https://console.ng.bluemix.net/registration/?target=%2Fdashboard%2Fapps
	
	or log in to an existing one
	
2. Create new app
	1. In your dashboard click on 'Create App'
	2. Find 'Visual Recognition'
	3. Fill out the form and proceed with 'Create' button
	
3. Aquire service 'api_key'
	1. On your service's main page click 'Service Credentials' tab.
	2. From the list choose your credentials and click on 'View Credentials'
	3. Copy Your 'api_key'.
	

4. SPSS Modeler and R requirements:
	- SPSS Modeler v18.0
	- SPSS Modeler 'R essentials' plugin
	- R packages: 
		- httr
		- RJSONIO
		- RCurl
		
5. Install WatsonVisualRecognition extension from SPSS Modeler Extension Hub.

You can now start classifying your images!

# Example usage

Example stream

<p align="center">
  <img src="Screenshot/stream.PNG"/ width=300px>
</p>

Example images

<p align="center">
  <img src="https://cdn.pixabay.com/photo/2016/04/20/22/32/golden-retriever-1342263_1280.jpg"/ width=100px>  
  <img src="https://upload.wikimedia.org/wikipedia/commons/e/e9/Goldfish3.jpg"/ width=100px>
  <img src="https://cdn.pixabay.com/photo/2016/05/18/20/57/cat-1401557_1280.jpg"/ width=100px>
</p>


WatsonVisualRecognition node requires a connected source. In our example a 'Var. File' node will be used.
The source must contain two lists of variables: one will be your pictures id or names, the other the urls you wish to analyze.

<p align="center">
  <img src="Screenshot/input1.PNG"/ width=300px>
</p>

	
In the node window you must provide the 'api_key' for your bluemix service and choose appropriate fields in the Image URLS and Image IDS.
Optionally you can specify custom classifier or api version. To learn more about custom classifiers check out: 
[ classifier link ]

<p align="center">
  <img src="Screenshot/input2.PNG"/ width=300px>
</p>
	
	
# Output

The generated output is a table that contains the picture ids, picture urls, class names and their respective scores. 
Note that for one image the number of generated table entries depends on the number of classes assigned to picture by the classifier.
	
<p align="center">
  <img src="Screenshot/output.PNG"/ width=300px>
</p>
	
# License
- [Apache 2.0][1]

# Contributors
- Artur Kucia
- Mateusz Mika

 [1]: http://www.apache.org/licenses/LICENSE-2.0.html
