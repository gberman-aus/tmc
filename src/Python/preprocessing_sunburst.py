
# requirements
import plotly.graph_objects as go
import plotly.express as px
import numpy as np

data = dict(
    id = ["SE",
            "SO",   "DS",  "S-E","CS", "CV",  
            "SO_ML","DS_ML", "S-E_ML", "CS_ML", "CV_ML",
            "SO_LP", "DS_LP",
            "SO_ML_KT", "DS_ML_KT", "CS_ML_KT", "CV_ML_KT",
            "SO_LP_KT", "DS_LP_KT",
            "SO_ML_KT_FD", "DS_ML_KT_FD", "CS_ML_KT_FD", "CV_ML_KT_FD",
            "SO_LP_KT_FD", "DS_LP_KT_FD",],
    parent = [ "",
                "SE",   "SE",  "SE","SE", "SE",  
                "SO",   "DS",    "S-E",    "CS",    "CV",    
                "SO",    "DS",
                "SO_ML", "DS_ML", "CS_ML", "CV_ML",
                "SO_LP", "DS_LP",
                "SO_ML_KT", "DS_ML_KT", "CS_ML_KT", "CV_ML_KT",
                "SO_LP_KT", "DS_LP_KT"],
    value= [556692, 
                463135, 25694, 707, 3786, 63370, 
                387868, 25322,   707,     3786,    63370,   
                75267,   372,
                35757, 933, 4, 246,
                9513, 121,
                15446, 460, 3, 136,
                5417, 93],
    name = ["Stack Exchange<br>(556,692)",
            "Stack Overflow", "Data Science", " ", " ", "Cross Validated", 
            "ML posts", "ML posts", " ", " ", "ML posts", 
            "LP posts", " ",
            "Key terms<br>filter", "Key terms<br>filter", " ", "Key terms<br>filter",
            "   Key terms<br>filter", " ",
            "Final dataset<br>(15,446)", "Final dataset<br>(460)", "", "Final dataset<br>(136)",
            "Final dataset<br>(5,417)", ""],
    depth = ['0', 
                '1', '2', '3', '4', '5',
                '6', '6','6','6','6',
                '7','7',
                '6','6','6','6',
                '7','7',
                '6','6','6','6',
                '7','7',],
)

fig = px.sunburst(
    data, 
    ids='id',
    names='name',
    parents='parent',
    values='value',
    color='depth',
    branchvalues='total',
)

fig.update_layout(margin= dict(t=0, l=0, r=0, b=0))
fig.update_layout(width=650, height=600,)
fig.update_layout(uniformtext=dict(minsize=10, mode='show'))
fig.write_image("sunburst.png")