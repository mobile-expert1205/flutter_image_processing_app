#include "LaneDetector.hpp"
#import <opencv2/opencv.hpp>
#include <TesseractOCR/baseapi.h>
using namespace cv;
using namespace std;

//double getAverage(vector<double> vector, int nElements) {
//
//    double sum = 0;
//    int initialIndex = 0;
//    int last30Lines = int(vector.size()) - nElements;
//    if (last30Lines > 0) {
//        initialIndex = last30Lines;
//    }
//
//    for (int i=(int)initialIndex; i<vector.size(); i++) {
//        sum += vector[i];
//    }
//
//    int size;
//    if (vector.size() < nElements) {
//        size = (int)vector.size();
//    } else {
//        size = nElements;
//    }
//    return (double)sum/size;
//}

int getContourPrecedance(Mat contour,int cols) {
    int toleranceFactor = 10;
    cv::Rect origin = cv::boundingRect(contour);
    
    return ((origin.y/toleranceFactor)*toleranceFactor)*cols+origin.x;
    
}



vector<Mat> sortContours(vector<Mat> contours,int width){
    //kindly confirm this, method . i have to do manually sorting, because it does not have any built in method. so i am just saving precedance.
    //can you explain how it should work so i do it accrodingly
    vector<Mat> sorted;
    
    vector<int> precendanceArr;
    vector<int> indArr;
    
    for (int i=0; i<contours.size(); i++) {
        
        int precedance = getContourPrecedance(contours[i],width);
        
        precendanceArr.push_back(precedance);
        indArr.push_back(i);
    }
    
    for (int i = 0; i < contours.size(); i++){
        for(int j = i + 1; j < contours.size(); j++){
            if(precendanceArr[i] > precendanceArr[j]){
                int tmp = precendanceArr[i];
                precendanceArr[i] = precendanceArr[j];
                precendanceArr[j] = tmp;
                
                tmp = indArr[i];
                indArr[i] = indArr[j];
                indArr[j] = tmp;
            }
        }
    }
    
    for (int i=0; i<contours.size(); i++) {
        sorted.push_back(contours[indArr[i]]);
    }
    
    return sorted;
}

int getSquareSize(vector<Mat> contours){
    int values[contours.size()*2];
    
    for (int i=0; i<contours.size(); i+=2) {
        Mat el = contours[i];
        
        
        cv::Rect rect = cv::boundingRect(el);
        
        int w = rect.width;
        int h = rect.height;
        
        values[i] =w;
        values[i+1]=h;
    }
    
    
    int mostFrequent = 0;
    
    int rlt =0;
    
    for (int i=0; i<contours.size()*2; i++) {
        int el = values[i];
        
        
        int frequency = 0;
        
        for (int j=0; j<contours.size()*2; j++) {
            if(el == values[j]){
                frequency++;
            }
        }
        
        
        if(frequency>mostFrequent){
            mostFrequent = frequency;
            rlt = values[i];
        }
    }
    
    return rlt;
    
}



vector<int> is_rect_in_a_center(int xo, int yo,int xf,int yf,int cells,cv::Rect rect){
    bool is_in = false;
    
    int x_cell = -1;
    int y_cell = -1;
    
    int w_rect = rect.width;
    int h_rect = rect.height;
    int x_rect = rect.x;
    int y_rect = rect.y;
    
    for (int i=1; i<=cells; i++) {
        for (int j=1; j<=cells; j++) {
            int x_center = int((j - 0.5) * (xf - xo) / cells) + xo;
            
            int y_center = int((i - 0.5) * (yf - yo) / cells) + yo;
            
            if (x_center >= x_rect && y_center >= y_rect && x_center <= x_rect + w_rect && y_center <= y_rect + h_rect) {
                if (!(is_in)) {
                    is_in = true;
                    x_cell = j;
                    y_cell = i;
                } else {
                    x_cell = -10;
                    y_cell = -10;
                }
            }
        }
    }
    
    vector<int> arr;
    
    arr.push_back(is_in?1:0);
    arr.push_back(x_cell);
    arr.push_back(y_cell);
    
    return arr;
}

Mat resize_image_32(Mat image){
    double height = image.rows * (32/double(image.cols));
    
    double width = 32.0;
    cv::Size dim = cv::Size(width,height);
    
    Mat resized;
    
    cv::resize(image, resized, dim);
    
    return  resized;
    
}

String get_ocr(tesseract::TessBaseAPI *ocr,Mat image,int cont){
    ocr->SetImage(image.data, image.cols, image.rows, 3, image.step);
    
    String text = ocr->GetUTF8Text();
    
    
    return text;
    
}
Mat process_letters_to_play(tesseract::TessBaseAPI *ocr,vector<vector<string>> global_board,Mat image, int xo, int yo,int xf,int yf,int cells){
    
    Mat board;
    image.copyTo(board);
    int yf2 = image.rows;
    
    int gray_low = 0;
    int gray_high = 50;
    int fill = 255;
    
    Mat gray_board,mask_gs,letters;
    
    cv::cvtColor(board, gray_board, COLOR_BGR2GRAY);
    inRange(gray_board, cv::Scalar(double(gray_low),double(gray_low),double(gray_low)), cv::Scalar(double(gray_high),double(gray_high),double(gray_high)), mask_gs);
    
    gray_board.copyTo(letters);
    
    cv::rectangle(letters, cv::Point(0.0,0.0), cv::Point(double(gray_board.cols),double(gray_board.rows)), cv::Scalar(255.0,255.0,255.0),FILLED);
    cv::copyTo(
    
    
    
    
    
}


Mat process_white_letters(tesseract::TessBaseAPI *ocr,vector<vector<string>> global_board,Mat image, int xo, int yo,int xf,int yf,int cells){
    Mat hsv_board;
    Mat gray_board;
    Mat img;
    
    cv::cvtColor(image, hsv_board, COLOR_BGR2HSV);
    cv::cvtColor(image, gray_board, COLOR_BGR2GRAY);
    
    image.copyTo(img);
    
    double w_c = (xf-xo)/cells;
    
    double h_c = (xf-yf)/cells;
    
    int max_height = 112;
    int total_width = 32 * 225;
    int padding = 5;
    
    Mat out;
    
    out = Mat(max_height,255*padding+total_width,CV_8UC1);
    
    cv::rectangle(out, cv::Point(0.0,0.0), cv::Point(double(225 * padding + total_width),double(max_height)), cv::Scalar(255.0,255.0,255.0),FILLED);
    
    int current_x = 40;
    int cont = 0;
    
    vector<vector<int>> cell_position = vector<vector<int>>();
    
    Mat r;
    
    for (int i;i<=cells;i++){
        
        for(int j;j<=cells;j++){
            if(global_board[i][j] == "-"){
                bool blank_cell = true;
                int x_from = xo + int(j*w_c);
                int y_from = yo + int(i*h_c);
                int x_to = xo + int((j + 1) * w_c);
                int y_to = yo + int((i + 1) * h_c);
                Mat gray_cell,hsv_cell;
                
                gray_cell = gray_board(cv::Rect(y_from, y_to, x_from, x_to));
                
        
                Mat mask_white;
                inRange(gray_cell, cv::Scalar(240.0,255.0), cv::Scalar(240.0,255.0), mask_white);
                Mat mask_hsv;
                hsv_cell = gray_board(cv::Rect(y_from, y_to, x_from, x_to));
                inRange(hsv_cell, cv::Scalar(98.0,50.0,150.0), cv::Scalar(110.0,200.0,255.0), mask_hsv);
                
                int ww = x_to - x_from;
                int hh = y_to - y_from;
                int x_center = int(ww / 2);
                int y_center = int(hh / 2);
                
                Mat hierarchy;
                
                vector<Mat> contours;
                
                findContours(mask_white, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_NONE);
                
                for (int i=0; i<contours.size(); i++) {
                    Mat value = contours[i];
                    
                    cv::Rect rect = cv::boundingRect(value);
                    
                    int w = rect.width;
                    int h = rect.height;
                    int x = rect.x;
                    int y = rect.y;
                    
                   
                    if (x_center >= x && y_center >= y && x_center <= x + w && y_center <= y + h && w / ww < 0.85 && h / hh < 0.85 && h / hh > 0.40 && contourArea(value) / (w * h) > 0.28) {
                        cont += 1;
                        
                        Mat input;
                        Mat finalInput;
                        
                        input = Mat(mask_white, cv::Rect(x,y,w,h));
                        
                        
                        
                        Mat m = Mat(input.rows,input.cols,255.0);
                        
                        subtract(m, input, finalInput);
                        
                        r = resize_image_32(finalInput);
                        
                        int wr = r.cols;
                        int hr = r.rows;
                        
                        vector<int> arr ;
                        arr.push_back(i);
                        arr.push_back(j);
                        
                        cell_position.push_back(arr);
                        
                        r.copyTo(out(cv::Rect(40, 40 + hr, current_x, current_x + wr)));
                        current_x += wr + padding;
                        blank_cell = false;
                    }//end if
                
                    
                }//end for
                
                
                if(blank_cell){
                    findContours(mask_hsv, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_NONE);
                    
                    for (int i=0; i<contours.size(); i++) {
                        Mat value = contours[i];
                        
                        cv::Rect rect = cv::boundingRect(value);
                        
                        int w = rect.width;
                        int h = rect.height;
                        int x = rect.x;
                        int y = rect.y;
                    
                        if (x_center >= x && y_center >= y && x_center <= x + w && y_center <= y + h && w / ww < 0.85 && h / hh < 0.85 && h / hh > 0.40 && contourArea(value) / (w * h) > 0.28) {
                            cont += 1;
                            
                            Mat input;
                            Mat finalInput;
                            
                            // to be decided
                            input = Mat(mask_white, Rect(x,y,w,h));
                            
                            Mat m = Mat(input.rows,input.cols,255.0);
                            
                            subtract(m, input, finalInput);
                            
                            r = resize_image_32(finalInput);
                            
                            int wr = r.cols;
                            int hr = r.rows;
                            
                            vector<int> arr ;
                            arr.push_back(i);
                            arr.push_back(j);
                            
                            cell_position.push_back(arr);
                            // to be decided
                            r.copyTo(out(cv::Rect(40, 40 + hr, current_x, current_x + wr)));
                            current_x += wr + padding;
                            blank_cell = false;
                        }
                        
                        
                    }
                }
                
                if (blank_cell) {
                    global_board[i][j] = " ";
                }
                
            }
        }
        
    }
    
    Mat res_out = out(cv::Rect(0, max_height, 0, current_x + 40));
    
    String text_ocr = get_ocr(ocr,res_out,cont);
    
    if(text_ocr.length()==cont){
        for(int i=0;i<text_ocr.length();i++){
            global_board[cell_position[i][1]][cell_position[i][0]] = text_ocr[i];
        }
    }
    
    
    cv::Point position = cv::Point(20.0, 100.0);
    cv::Scalar color = cv::Scalar(0.0, 0.0, 0.0);
    cv::HersheyFonts font = FONT_HERSHEY_SIMPLEX;
    double scale = 1.0;
    int thickness = 3;
    Mat white_image;
    gray_board.copyTo(white_image);
    
    cv::rectangle(out, cv::Point(0.0,0.0), cv::Point(double(gray_board.cols),double(gray_board.rows)), cv::Scalar(255.0,255.0,255.0),FILLED);
    
    cv::putText(white_image, text_ocr, position, font, scale, color,thickness);
    
    return white_image;
    
    
}


Mat process_black_letters(tesseract::TessBaseAPI *ocr,vector<vector<string>> global_board,Mat image, int xo, int yo,int xf,int yf,int cells){
    Mat board = image;
    double gray_low = 0.0;
    double gray_high = 50.0;
    int image_w = image.cols;
    int image_h = image.rows;
    
    Mat gray_board;
    
    cv::cvtColor(image, gray_board, COLOR_BGR2GRAY);
    
    Mat mask_gs;
    
    cv::inRange(gray_board, gray_low, gray_high, mask_gs);
    
    
    Mat letters = gray_board;
    
    cv::rectangle(letters, cv::Point(0.0,0.0), cv::Point(double(image_w),double(image_h)), cv::Scalar(255.0,255.0,255.0),FILLED);
    
    
    copyTo(gray_board, letters, mask_gs);
    
    Mat heirarchy;
    
    vector<Mat> contours;
    
    findContours(mask_gs, contours, heirarchy, RETR_LIST, CHAIN_APPROX_NONE);
    
    
    int w_c = (xf - xo) / cells;
    int h_c = (yf - yo) / cells;
    
    int max_height = 112;
    int total_width = 32 * 225;
    int padding = 5;
    
    Mat out = Mat(max_height,255*padding+total_width,CV_8UC1);
    
    cv::rectangle(out, cv::Point(0.0,0.0), cv::Point(double(225 * padding + total_width),double(max_height)), cv::Scalar(255.0,255.0,255.0),FILLED);
    
    int current_x = 40;
    int cont = 0;
    
    vector<vector<int>> cell_position = vector<vector<int>>();
    
    contours = sortContours(contours, mask_gs.cols);
    
    Mat r;
    
    int resp_cnt = 0;
    
    for (int i=0; i<contours.size(); i++) {
        Mat value = contours[i];
        
        cv::Rect rect = cv::boundingRect(value);
        
        int w = rect.width;
        int h = rect.height;
        int x = rect.x;
        int y = rect.y;
        
        bool found = false;
        
        int x_cell = -1;
        
        int y_cell = -1;
        
        int wr =0;
        
        int hr =0;
        
        
        if(y >= yo && y <= yf && x >= xo && x <= xf){
            resp_cnt+=1;
            vector<int> arr = is_rect_in_a_center(xo, yo, xf, yf, cells, rect);
            found = arr[0]==1?true:false;
            x_cell = arr[1];
            y_cell = arr[2];
            
            if(found&& x_cell>0){
                vector<int> temp;
                
                temp.push_back(x_cell);
                temp.push_back(y_cell);
                cell_position.push_back(temp);
                cont+=1;
                
                cv::Mat input = cv::Mat(letters,cv::Rect(x,y,w,h));
                
                r = resize_image_32(input);
                
                wr = r.cols;
                hr = r.rows;
                
                r.copyTo(out(cv::Rect(40,40+hr,current_x,current_x+wr)));
                
                current_x += wr + padding;
                
                
                
            }
        }
    }
    
    Mat res_out = out(cv::Rect(0, max_height, 0, current_x + 40));
    
    String text_ocr = get_ocr(ocr,res_out,resp_cnt);
    
    for(int i=0;i<text_ocr.length();i++){
        global_board[cell_position[i][1]-1][cell_position[i][0]-1] = text_ocr[i];
    }
    
    
    cv::Point position = cv::Point(20.0, 100.0);
    cv::Scalar color = cv::Scalar(0.0, 0.0, 0.0);
    cv::HersheyFonts font = FONT_HERSHEY_SIMPLEX;
    double scale = 1.0;
    int thickness = 3;
    Mat white_image;
    gray_board.copyTo(white_image);
    
    cv::rectangle(out, cv::Point(0.0,0.0), cv::Point(double(image_w),double(image_h)), cv::Scalar(255.0,255.0,255.0),FILLED);
    
    cv::putText(white_image, text_ocr, position, font, scale, color,thickness);
    
    return white_image;
    
}


Mat LaneDetector::detect_lane(Mat input) {
    
    //ocr initialization
    tesseract::TessBaseAPI *ocr = new tesseract::TessBaseAPI();
    
    ocr->Init(NULL, "eng", tesseract::OEM_DEFAULT);
    
    vector<vector<string>> global_board;
    
    Mat image = input;
    Mat image2 = input;
    Mat tmp_img = input;
    Mat orig_img = input;
    
    int image_w = image.cols;
    int image_h = image.rows;
    
    int left[4];
    left[0]= image_w;
    left[1]= 0;
    left[2]= 0;
    left[3]= 0;
    int right[4];
    right[0]= 0;
    right[1]= 0;
    right[2]= 0;
    right[3]= 0;
    
    int top[4];
    top[0]= 0;
    top[1]= image_h;
    top[2]= 0;
    top[3]= 0;
    
    int top_2nd[4];
    top_2nd[0]= 0;
    top_2nd[1]= image_h;
    top_2nd[2]= 0;
    top_2nd[3]= 0;
    
    int bottom[4];
    bottom[0]= 0;
    bottom[1]= 0;
    bottom[2]= 0;
    bottom[3]= 0;
    
    Mat grayImage;
    
    try{
        cv::cvtColor(image, grayImage, COLOR_BGR2GRAY);
    }catch(Exception e){
        printf("exception ");
    }
    
    
    Mat blurImage;
    
    cv::GaussianBlur(grayImage, blurImage, Size(3,3),0);
    
    
    Mat edges = grayImage;
    
    cv::Canny(blurImage, edges, 30.0, 30.0);
    
    
    Mat letters = blurImage;
    
    cv::rectangle(letters, Point(0.0,0.0), Point(double(image_w),double(image_h)), Scalar(0.0,0.0,0.0),FILLED);
    
    Mat heirarchy = letters;
    
    vector<Mat> contours;
    
    findContours(edges, contours, heirarchy, RETR_LIST, CHAIN_APPROX_NONE);
    
    
    for (int i=0; i<contours.size(); i++) {
        Mat value = contours[i];
        
        Rect rect = cv::boundingRect(value);
        
        int w = rect.width;
        int h = rect.height;
        int x = rect.x;
        int y = rect.y;
        
        double rect_aspect = w/double(h);
        
        double contour_squareness = cv::contourArea(value)/double(w*h);
        
        if(rect_aspect>0.0 && rect_aspect<1.1 && w>image_w/20.0 && w<image_w/10.0&&contour_squareness>0.85 && contour_squareness<1.15){
            
            cv::rectangle(letters, Point(double(x),double(y)), Point(double(x+w-1),double(y+h-1)), Scalar(255.0,255.0,255.0),-1);
        }
    }
    
    
    vector<Mat> temp_contours;
    
    findContours(letters,temp_contours, heirarchy, RETR_LIST, CHAIN_APPROX_NONE);
    
    temp_contours = sortContours(temp_contours, edges.cols);
    
    
    int squareSize = getSquareSize(temp_contours);
    
    
    for (int i=0; i<temp_contours.size(); i++) {
        Mat value = temp_contours[i];
        Rect rect = cv::boundingRect(value);
        
        int w = rect.width;
        int h = rect.height;
        int x = rect.x;
        int y = rect.y;
        
        int dif_w = abs(squareSize-w);
        int dif_h = abs(squareSize-h);
        
        
        int tolerance = int(squareSize/10)+1;
        
        if(dif_w<=tolerance && dif_h<=tolerance){
            
            if(x<left[0]){
                left[0] = x;
                left[1] = y;
                left[2] = rect.width;
                left[3] = rect.height;
            }
            
            if (x + w > right[0] + right[2]) {
                right[0] = x;
                right[1] = y;
                right[2] = rect.width;
                right[3] = rect.height;
            }
            
            if (y < top[1]) {
                top_2nd[0] = top[0];
                top_2nd[1] = top[1];
                top_2nd[2] = top[2];
                top_2nd[3] = top[3];
                top[0] = x;
                top[1] = y;
                top[2] = rect.width;
                top[3] = rect.height;
            } else if (y < top_2nd[1]) {
                top_2nd[0] = x;
                top_2nd[1] = y;
                top_2nd[2] = rect.width;
                top_2nd[3] = rect.height;
            }
            
            if (y + h > bottom[1] + bottom[3]) {
                bottom[0] = x;
                bottom[1] = y;
                bottom[2] = rect.width;
                bottom[3] = rect.height;
            }
            
        }//end if
        
        
    }//end for
    
    
    int xo = left[0];
    int yo = top_2nd[1];
    int xf = right[0]+right[2];
    int yf = bottom[1]+bottom[3];
    int divCells = (xf- xo)/squareSize;
    
    int cells = 0;
    
    if(divCells>15)
        cells =15;
    else if(divCells <11)
        cells = 9;
    else
        cells = 11;
    
    int innerSpace = ((xf-xo)-squareSize*cells)/ (cells-1);
    
    xo -= (innerSpace / 2); //boardleft
    xf += (innerSpace / 2); //board right
    yo -= (innerSpace / 2) ;//board top
    yf += (innerSpace / 2) ;//board bottom
    
    
    
    
    for (int x;x<=cells;x++){
        vector<String> arr;
        for(int y;y<=cells;y++){
            arr.push_back("-");
        }
        global_board.push_back(arr);
    }
    
    for (int i=0; i<temp_contours.size(); i++) {
        Rect rect = cv::boundingRect(temp_contours[i]);
        vector<int> resp = is_rect_in_a_center(xo, yo, xf, yf, cells, rect);
        
        bool found = resp[0]==1?true:false;
        
        bool x_cell = resp[1];
        bool y_cell = resp[2];
        
        if(found && x_cell>0){
            global_board[y_cell-1][x_cell-1] = " ";
        }
    }
    
    
    Mat output = cv::Mat(orig_img, Rect(xo,yo, xf-xo, yf-yo));
    
    
    
    //cv::imwrite(path, output);
    
    return output;
    
    
}

//int LaneDetector::getContourPrecedance(Mat contour,int cols) {
//    int toleranceFactor = 10;
//    Rect origin = cv::boundingRect(contour);
//
//    return ((origin.y/toleranceFactor)*toleranceFactor)*cols+origin.x;
//
//}



//
//
//
//
//Mat LaneDetector::crop_region_of_interest(Mat image) {
//
//    /*
//     The code below draws the region of interest into a new image of the same dimensions as the original image.
//     The region of interest is filled with the color we want to filter for in the image.
//     Lastly it combines the two images.
//     The result is only the color within the region of interest.
//     */
//
//    int maxX = image.rows;
//    int maxY = image.cols;
//
//    Point shape[1][5];
//    shape[0][0] = Point(0, maxX);
//    shape[0][1] = Point(maxY, maxX);
//    shape[0][2] = Point((int)(0.55 * maxY), (int)(0.6 * maxX));
//    shape[0][3] = Point((int)(0.45 * maxY), (int)(0.6 * maxX));
//    shape[0][4] = Point(0, maxX);
//
//    Scalar color_to_filter(255, 255, 255);
//
//    Mat filledPolygon = Mat::zeros(image.rows, image.cols, CV_8UC3); // empty image with same dimensions as original
//    const Point* polygonPoints[1] = { shape[0] };
//    int numberOfPoints[] = { 5 };
//    int numberOfPolygons = 1;
//    fillPoly(filledPolygon, polygonPoints, numberOfPoints, numberOfPolygons, color_to_filter);
//
//    // Cobine images into one
//    Mat maskedImage;
//    bitwise_and(image, filledPolygon, maskedImage);
//
//    return maskedImage;
//}
//
//Mat LaneDetector::draw_lines(Mat image, vector<Vec4i> lines) {
//
//    vector<double> rightSlope, leftSlope, rightIntercept, leftIntercept;
//
//    for (int i=0; i<lines.size(); i++) {
//        Vec4i line = lines[i];
//        double x1 = line[0];
//        double y1 = line[1];
//        double x2 = line[2];
//        double y2 = line[3];
//
//        double yDiff = y1-y2;
//        double xDiff = x1-x2;
//        double slope = yDiff/xDiff;
//        double yIntecept = y2 - (slope*x2);
//
//        if ((slope > 0.3) && (x1 > 500)) {
//            rightSlope.push_back(slope);
//            rightIntercept.push_back(yIntecept);
//        } else if ((slope < -0.3) && (x1 < 600)) {
//            leftSlope.push_back(slope);
//            leftIntercept.push_back(yIntecept);
//        }
//    }
//
//    double leftAvgSlope = getAverage(leftSlope, 30);
//    double leftAvgIntercept = getAverage(leftIntercept, 30);
//    double rightAvgSlope = getAverage(rightSlope, 30);
//    double rightAvgIntercept = getAverage(rightIntercept, 30);
//
//    int leftLineX1 = int(((0.65*image.rows) - leftAvgIntercept)/leftAvgSlope);
//    int leftLineX2 = int((image.rows - leftAvgIntercept)/leftAvgSlope);
//    int rightLineX1 = int(((0.65*image.rows) - rightAvgIntercept)/rightAvgSlope);
//    int rightLineX2 = int((image.rows - rightAvgIntercept)/rightAvgSlope);
//
//    Point shape[1][4];
//    shape[0][0] = Point(leftLineX1, int(0.65*image.rows));
//    shape[0][1] = Point(leftLineX2, int(image.rows));
//    shape[0][2] = Point(rightLineX2, int(image.rows));
//    shape[0][3] = Point(rightLineX1, int(0.65*image.rows));
//
//    const Point* polygonPoints[1] = { shape[0] };
//    int numberOfPoints[] = { 4 };
//    int numberOfPolygons = 1;
//    Scalar fillColor(0, 0, 255);
//    fillPoly(image, polygonPoints, numberOfPoints, numberOfPolygons, fillColor);
//
//    Scalar rightColor(0,255,0);
//    Scalar leftColor(255,0,0);
//    line(image, shape[0][0], shape[0][1], leftColor, 10);
//    line(image, shape[0][3], shape[0][2], rightColor, 10);
//
//    return image;
//}
//
//Mat LaneDetector::detect_edges(Mat image) {
//
//    Mat greyScaledImage;
//    cvtColor(image, greyScaledImage, COLOR_RGB2GRAY);
//
//    Mat edgedOnlyImage;
//    Canny(greyScaledImage, edgedOnlyImage, 50, 120);
//
//    return edgedOnlyImage;
//}
