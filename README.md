# MatlabQuickUI
An easy way to build complex Matlab GUIs for user input **in seconds**!
   
Example:  

![image](https://user-images.githubusercontent.com/50057077/71688767-69b57500-2d98-11ea-8f0e-254b9bf381c0.png)
  
  
Request user input according to instructions from a text file  
  
**Syntax**  
str = QuickUI(filename)  
  
**Description**  
QuickUI displays a user interface and waits for the user to input and press Ok key.  
If the user closes, then input returns an empty matrix.  
  
**Input Arguments**  
filename is a full path or a name of a text file where the instructions  
of the UI appears.  
The text file may include the following instructions:  
* *title FIGURE TITLE* - Sets the title of the UI to FIGURE TITLE.  
* *panel NAME*            -   Opens a panel with the name NAME.   
* *radiogroup NAME*       -   Opens a radio group panel with the name NAME.   
* *end*                   -   closes a panel. Each panel should be closed  
* *radio STR*             -   Adds a radio button with the string STR, if STR = N/A and N/A is checked then this radio group will not be included in the output.  
* *checkbox STR*          -   Adds a checkbox with the text STR.  
* *textbox STR*           -   Adds an editable text box following the text STR.  
* *list STR1;STR2;STR3...*-   Adds a list to choose from the options STR1, STR2, STR3, etc.  
* *commentbox STR*        -   Adds a big editable text that shows the default text STR  
* *text STR*              -   Adds the non-editable text STR.      
  
**Example:**  
`str = quickinputui("ExampleFile.txt")`  
ExampleFile.txt contains:  
~~~~
title Example  
panel Panel 1   
radiogroup Choose a radio button  
radio N/A  
radio Option 1  
radio Option 2  
end  
text This is plain text  
checkbox Check this  
checkbox And this  
checkbox Not this  
textbox Write a number  
list what do you want?;option1;option2  
end  
commentbox Comment here  
text Thank you!  
~~~~
  
The output from the example above would be a string containing:
``` 
Panel 1 : {   
              Check this;    
              And this;   
              Write a number: 5;  
              what do you want?: option1 
           };  
Comment here : Comment  
```


License
-------

Licensed under the [MIT License](LICENSE.md). &copy; Amir Goldental
