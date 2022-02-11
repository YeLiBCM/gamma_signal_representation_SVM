# Usage of Support Vector Machine (SVM) in brain science 
## -- an example of investigating the neural function of gamma activity in the human visual cortex

This repository provides the code for implementing the machine learning modeling in the paper "Functionally Distinct Gamma Range Activity Revealed by Stimulus Tuning in Human Visual Cortex".

If you are a neuroscientist, check the link of the paper to see the method: https://www.cell.com/current-biology/pdfExtended/S0960-9822(19)31020-6. And check the __main_SVM__ notebook to see the core code for the classification pipeline.

If you are an beginner in brain sciense, or if you are just interested in how neuroscientist use machine learning in their research, here I will explain the research story and the method logic behind it in a simpler way.

__The general use case:__ <br>
Unlike in industry, where people build models aiming to have the prediction performance as better as they can, the purpose of using machine learning tools in brain science is often to test whether a given cognitive function is represented by a given brain signal or a given brain region. If some information is represented in a given brain signal, then we expect that the information can be __"decoded"__ from the brain signal. Here the decode means "predict". To be more specific in the modeling, if we use the brain signal as the model input, while the information as model output, we should be able to train a model with the prediction performance higher than chance level. Otherwise, the brain signal is not representing the information/cognitive function that we care about (this is also our null hypothesis).

__Why I use SVM in my studies?__ <br>
Scientists may choose differenct models to test the "representation" question, from very simple linear regression to fancy deep learning model. However, SVM is commonly used in some fields, especially in those fMRI studies, for the following reasons:
1) The data can not meet the assumptions of some simpler models (e.g. linear regression); 
2) Brain data is different to collect (especially in human studies, you may see more deep learning models in monkey studies), with a small sample size, SVM are easier to train compared to some other models (e.g. logistic regression);
3) Sometime __interpretation__ is very important for projects in brain science! In this case, a linear SVM will be very helpful and provides you with extra informaction if the model has an acceptable prediction performance.

SVM happens to fit my needs of my project in the above three points!

__The "big question" of my project:__ <br>
Existing studies found that gamma oscillation in the human brain is relevant to some cognitive functions, like perception, attention and memory. However, the range of gamma was defined as a big range: 20Hz to 150Hz. Our lab found that there are two subset ranges of the traditionally defined gamma: a narrow band gamma (NBG, 20-60Hz) and a broad band gamma (BBG, 70-150Hz), showing different properties. By eyeballing the time-frequency plots (see my paper with the link above) we can already see that NBG shows more dependency to visual stimulus properties (here we choose the contrast of the grating stimulus as the property to study) compared to BBG. However, we want to use the SVM to quantify the effect. 

To be more specific, we will use SVM to answer the following questions:
1) Does NBG represent the contrast information? 
2) Does BBG represent the contrast information?

Note: here I am talking about gamma oscillations in the visual cortex, because we use visual stimuli to trigger the gamma.

__The method pipeline__: <br>
Though I will not provide all the code used in my project, here is the method pipeline of this study (You don't need to worry about the first three steps if you don't work with ECoG or EEG data):
1) Convert the Electrocorticography (ECoG) data collected with Blackrock system into .mat file. (MATLAB, code not provided in repository)
2) Filter the data, re-reference data (I used common average method), identify bad channels, decompose the data using wavelet transform. (MATLAB, code not provided in repository)
3) Extract the photodiode signal we collected into event file. (MATLAB, code not provided in repository)
4) Use event information to cut the whole task block brain data into trial-wise data. (MATLAB, "extract_epoch.m")
5) Train and test using linear SVM with the leave-one-out cross validation with either NBG or BBG. (python, "main_SVM.ipynb")
6) Apply permutation test to get the significance level (p-value) of the model performance. (python, "main_SVM.ipynb")
7) Save the prediction accuracy and p-value for further analysis like Chi-square test mentioned in my paper. (python, "main_SVM.ipynb")

__If you want to know more__: <br>
You may only need a few lines of code to implement the machine learning modeling for your research project! (See how less code is in my "main_SVM.ipynb") However, you can do lots of exploration and analysis to find out which model or what parameters to use.

If you are interested in how I decide which model to use, check the notebook "find_model.ipynb".

__Contact__: <br>
Contact me (liye1992@gmail.com) if you have any question!
