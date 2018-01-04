1.trimap的生成是利用Canny边缘检测和膨胀腐蚀操作。
2.在有原图和trimap的基础上，利用knn matting进行了抠图操作。

3.程序运行方式，MATLAB打开该文件夹，定位到src目录下，运行run_demo2.m,即可得到结果。run_demo.m是处理了另一张图，也可以直接运行。
