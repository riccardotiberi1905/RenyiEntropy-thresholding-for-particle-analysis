function [image_adj] = Color_Equalization(image)

%{
        Function description.

        This function receives an RGB image. A histogram equalization is
        performed according to the established color channels: blue_ref;
        green_ref and red_ref. The outcome is a contrast enhanced RGB image
        that makes further image segmentation more feasible.

        Parameters
        ----------
        image : 3-channel uint8 matrix
            Original image.

        Returns
        -------
        image_adj : 3-channel uint8 matrix
            Adjusted image.

    %} 

blue_ref=[629
113
111
110
153
160
185
236
292
370
388
658
627
788
918
1040
1230
1475
1627
1931
2169
2419
2975
3172
3392
3857
4170
4960
4772
5264
5001
5167
4974
4903
4618
4160
3954
3365
3141
2684
2373
2063
1821
1676
1433
1237
1164
974
908
771
646
622
520
486
374
371
348
273
230
192
193
172
161
154
122
114
85
96
115
96
97
72
69
89
68
63
64
70
86
66
71
68
79
87
75
73
76
79
71
78
68
87
71
74
80
79
96
89
73
71
76
83
86
77
73
82
76
80
98
84
96
81
72
101
105
108
98
104
115
110
106
130
131
139
156
125
159
162
196
248
239
494
482
1032
982
2367
3118
4170
7440
4973
13224
6372
22632
9393
34165
19775
46629
49294
42541
113732
32371
120769
27128
151953
31164
170874
23582
76354
19418
52644
18490
49588
19877
64986
30494
121236
54645
116473
84369
92739
136935
91274
157323
157422
150146
154363
154136
106971
173197
83583
142029
50305
97856
25983
95246
22814
66725
37407
38438
42057
31951
37630
26422
69566
24920
184104
19696
284306
19673
595828
97219
560553
716615
261454
421291
100090
374109
28869
182786
5901
70814
2981
25243
934
2427
452
244
144
10
24
2
0
0
1
1
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0];

red_ref=[0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
1
0
1
0
2
1
0
0
1
6
7
5
4
3
5
9
13
9
6
13
13
14
20
20
30
26
27
26
30
37
40
37
39
51
54
58
79
61
65
99
91
111
93
104
123
105
158
168
156
135
157
177
184
194
175
206
196
231
244
235
256
268
265
313
328
311
371
375
436
483
606
755
811
1029
1346
1549
2055
2616
3377
4183
4963
6131
6903
7513
7850
8045
8151
7876
7820
8086
8263
8941
9344
13188
13900
28830
35948
102627
94171
172545
241420
173388
393002
228823
253731
166191
76686
158367
52649
169781
54366
300251
67575
284607
122726
238673
316683
327647
395812
1239061
392671
733355
324103
315798
160044
116250
67343
8073
20954
1682
744
155
114
84
61
54
46
54
49
39
28
26
20
8
15
10
14
14
7
4
7
7
2
2
1
2
1
1
3
1
2
0
0
0
0
0
0
0
2];

green_ref=[146
84
110
132
188
280
327
444
600
721
912
1154
1329
1773
2103
2450
2782
3299
3731
4228
4700
5200
5387
5567
5811
5536
5547
5178
4709
4390
4013
3431
3225
2642
2433
2103
1760
1441
1271
1155
957
848
724
647
586
511
501
396
377
359
281
236
237
260
172
192
181
150
142
134
121
116
113
88
108
91
84
74
76
59
67
80
77
61
62
66
62
62
66
52
45
71
53
50
65
62
58
48
42
46
64
56
58
52
44
58
56
61
49
54
50
52
50
38
43
53
62
43
49
43
70
53
59
52
45
71
64
60
57
63
75
69
74
74
89
71
99
73
88
93
83
90
96
93
79
88
96
100
87
97
103
97
92
84
108
104
117
141
139
130
144
180
204
226
297
406
535
653
865
913
1108
1375
1481
2140
2305
2990
4029
5971
8312
13866
20410
38318
52104
100131
148629
178942
182439
135696
103229
61551
47866
35247
54421
63150
100949
171325
148921
187247
163700
141357
150020
104707
178762
159067
154711
145661
109465
108896
95503
115615
75068
93402
47445
84078
82797
243452
261213
1200501
382207
766702
370217
370199
187682
142370
49600
7750
2173
391
152
37
25
4
0
0
1
1
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0];

% Adjust the lighting of the image to match the reference image
image_adj = cat(3, histeq(image(:,:,1), red_ref), histeq(image(:,:,2), green_ref), histeq(image(:,:,3), blue_ref));    
end