package tips.word.wordfinderx

import android.content.Context
import android.content.res.AssetManager
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.NonNull
import com.googlecode.tesseract.android.TessBaseAPI
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.android.BaseLoaderCallback
import org.opencv.android.LoaderCallbackInterface
import org.opencv.android.OpenCVLoader
import org.opencv.core.*
import org.opencv.core.Core.copyTo
import org.opencv.core.Core.inRange
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import org.opencv.imgproc.Imgproc.*
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.lang.Math.abs
import java.util.*
import kotlin.collections.ArrayList


class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL = "tips.word.wordfinderx/image"
        private const val METHOD_GET_LIST = "find_board"
    }

    private lateinit var channel: MethodChannel
    lateinit var api: TessBaseAPI
    var global_board:ArrayList<ArrayList<String>> = ArrayList()

    lateinit var datapath: String
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        api = TessBaseAPI()

        val outputDir = cacheDir.absolutePath

        datapath = outputDir
        val dir: File = File(datapath.toString() + "/tessdata/")
        val file: File = File(datapath.toString() + "/tessdata/" + "eng.traineddata")
        if (!file.exists()) {
            Log.d("mylog", "in file doesn't exist")
            dir.mkdirs()
            copyFile(context)
        }

        api.init(datapath, "eng")


        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            if (methodCall.method == METHOD_GET_LIST) {
                val imagePath = methodCall.argument<String>("filePath").toString()

                global_board = ArrayList()
                Log.e("Path", imagePath.toString())

                val findBoardResponse: Array<Int> = findBoard(imagePath)

                var board_left = findBoardResponse[0]
                var board_top = findBoardResponse[1]
                var board_right = findBoardResponse[2]
                var board_bottom = findBoardResponse[3]
                var board_format = findBoardResponse[4]


                Log.e("Board","Board:  $board_format x  $board_format")

                val image : Mat = Imgcodecs.imread(imagePath)

                val blackLettersResp: Array<String>  = process_black_letters(image,  board_left, board_top, board_right, board_bottom, board_format)


                val stat1 = blackLettersResp[0]
                val black_chars = blackLettersResp[1]

                val image2 : Mat = Imgcodecs.imread(imagePath)


                val letters_to_play = process_letters_to_play(image2, board_left, board_top, board_right, board_bottom, board_format)


                val image3 : Mat = Imgcodecs.imread(imagePath)

                val white_letters = process_white_letters(image3, board_left, board_top, board_right, board_bottom, board_format)


                val x_c = (board_right - board_left) // board_format
                val y_c = (board_bottom - board_top) // board_format

                var img_board  = Mat()
                rectangle(img_board, Point(0.0, 0.0), Point(image.width().toDouble(), image.height().toDouble()), Scalar(255.0, 255.0, 255.0), Imgproc.FILLED)

                for(i in 0..board_format-1) {
                    line(img_board, Point((i * x_c).toDouble(), 0.0), Point((i * x_c).toDouble(), (board_bottom-board_top).toDouble()), Scalar(0.0, 0.0, 0.0), 1)

                    line(img_board, Point(0.0, (i * y_c).toDouble()), Point((board_right-board_left).toDouble(), (i * y_c).toDouble()), Scalar(0.0, 0.0, 0.0), 1)

                }

                for(i in global_board.indices){
                    Log.e("Globalboard", "${global_board[i]}")
                }

                Log.e("letters", " letters to play $letters_to_play")
                Log.e("letters", " black letters $black_chars")
                Log.e("letters", " white letters $white_letters")

                result.success("$black_chars;;$white_letters;;$letters_to_play")
            } else
                result.notImplemented()
        }
    }


    private fun copyFile(context: Context) {
        val assetManager: AssetManager = context.getAssets()
        try {
            val `in`: InputStream = assetManager.open("eng.traineddata")
            val out: OutputStream = FileOutputStream(datapath.toString() + "/tessdata/" + "eng.traineddata")
            val buffer = ByteArray(1024)
            var read: Int = `in`.read(buffer)
            while (read != -1) {
                out.write(buffer, 0, read)
                read = `in`.read(buffer)
            }
        } catch (e: java.lang.Exception) {
            Log.d("mylog", "couldn't copy with the following error : $e")
        }
    }


    fun getSquareSize(contours: List<MatOfPoint>): Int {

        val values: ArrayList<Int> = ArrayList()
        for (x in contours.indices) {

            val value: MatOfPoint = contours[x]

            val rect: Rect = Imgproc.boundingRect(value)

            val w = rect.width
            val h = rect.height

            values.add(w)
            values.add(h)
        }

        var mostFrequent = 0
        var rlt = 0

        for (x in values.indices) {
            val el = values[x]

            var frequency = 0
            for (y in values.indices) {
                if (el == values[y]) {
                    frequency++
                }
            }

            if (frequency > mostFrequent) {
                mostFrequent = frequency
                rlt = values[x]
            }
        }

        return rlt
    }

    fun getContourPrecedence(contour: Mat, cols: Int): Int {
        val toleranceFactor = 10
        val origin = Imgproc.boundingRect(contour)

        return ((origin.y / toleranceFactor) * toleranceFactor) * cols + origin.x
    }

    fun findBoard(path: String): Array<Int> {

        var arr : Array<Int>
        val image = Imgcodecs.imread(path)
        val image2 = Imgcodecs.imread(path)
        val tmp_img = Imgcodecs.imread(path)
        val ori_img = Imgcodecs.imread(path)

        val image_w = image.cols()
        val image_h = image.rows()

        val left = arrayOf(image_w, 0, 0, 0)
        val right = arrayOf(0, 0, 0, 0)
        val top = arrayOf(0, image_h, 0, 0)
        val top_2nd = arrayOf(0, image_h, 0,0)
        val bottom = arrayOf(0, 0, 0, 0)

        val grayImage = tmp_img

        Imgproc.cvtColor(image, grayImage, Imgproc.COLOR_BGR2GRAY)
        val blurImage = image
        Imgproc.GaussianBlur(grayImage, blurImage, Size(3.0, 3.0), 0.0)

        val edges: Mat = image2
        Imgproc.Canny(blurImage, edges, 30.0, 90.0)

        try {
            var letters = tmp_img
            Imgproc.rectangle(letters, Point(0.0, 0.0), Point(image_w.toDouble(), image_h.toDouble()), Scalar(0.0, 0.0, 0.0), Imgproc.FILLED)
            val hierarchy = Mat()

            var contours: List<MatOfPoint> = ArrayList()
            findContours(edges, contours, hierarchy, Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_NONE)

            for (l in contours.indices) {
                try {
                    val value: MatOfPoint = contours[l]
                    val rect: Rect = Imgproc.boundingRect(value)

                    val w = rect.width
                    val h = rect.height
                    val x = rect.x
                    val y = rect.y
                    val rect_aspect = w / (h).toDouble()

                    var contour_squareness = Imgproc.contourArea(value) / (w * h).toDouble()

                    if (rect_aspect > 0.90 && rect_aspect < 1.1 && w > image_w / 20.0 && w < image_w / 10.0 && contour_squareness > 0.85 && contour_squareness < 1.15) {
                        Imgproc.rectangle(letters, Point(x.toDouble(), y.toDouble()), Point((x + w - 1).toDouble(), (y + h - 1).toDouble()), Scalar(255.0, 255.0, 255.0), -1)
                    }
                } catch (e: Exception) {
                    Log.e("loop3", e.toString())
                }
            }

            var tempContours: List<MatOfPoint> = ArrayList()
            findContours(letters, tempContours, hierarchy, Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_NONE)

            tempContours = tempContours.sortedBy { getContourPrecedence(it, edges.width()) }

            val squareSize = getSquareSize(tempContours)
            
            try {
                //find biggest
                for (l in tempContours.indices) {
                    try {
                        val value: MatOfPoint = tempContours[l]
                        val rect: Rect = Imgproc.boundingRect(value)

                        val w = rect.width
                        val h = rect.height
                        val x = rect.x
                        val y = rect.y

                        val dif_w = abs(squareSize - w)
                        val dif_h = abs(squareSize - h)

                        val tolerance = (squareSize / 10.0).toInt() + 1

                        if (dif_w <= tolerance && dif_h <= tolerance) {
                            if (x < left[0]) {
                                left[0] = x
                                left[1] = y
                                left[2] = rect.width
                                left[3] = rect.height
                            }
                            if (x + w > right[0] + right[2]) {
                                right[0] = x
                                right[1] = y
                                right[2] = rect.width
                                right[3] = rect.height
                            }
                            if (y < top[1]) {
                                top_2nd[0] = top[0]
                                top_2nd[1] = top[1]
                                top_2nd[2] = top[2]
                                top_2nd[3] = top[3]
                                top[0] = x
                                top[1] = y
                                top[2] = rect.width
                                top[3] = rect.height
                            } else if (y < top_2nd[1]){
                                top_2nd[0] = x
                                top_2nd[1] = y
                                top_2nd[2] = rect.width
                                top_2nd[3] = rect.height
                            }
                            if (y + h > bottom[1] + bottom[3]) {
                                bottom[0] = x
                                bottom[1] = y
                                bottom[2] = rect.width
                                bottom[3] = rect.height
                            }
                        }
                    } catch (e: Exception) {
                        Log.e("loopexc", e.toString())
                    }
                }

            } catch (e: Exception) {
                Log.e("outexc", e.toString())
            }

            var xo = left[0]
            var yo = top_2nd[1]
            var xf = right[0] + right[2]
            var yf = bottom[1] + bottom[3]
            val divCells = (xf - xo).toDouble() / squareSize

            var cells = 0

            if (divCells > 15)
                cells = 15
            else if (divCells < 11)
                cells = 9
            else
                cells = 11

            val innerSpace = ((xf - xo) - squareSize * cells) / (cells - 1).toDouble()
            xo -= (innerSpace / 2).toInt()//boardleft
            xf += (innerSpace / 2).toInt() //board right
            yo -= (innerSpace / 2).toInt() //board top
            yf += (innerSpace / 2).toInt() //board bottom

            for(x in 0..cells-1){
                var arr : ArrayList<String> = ArrayList()
                for(y in 0..cells-1){
                    arr.add("-")
                }
                global_board.add(arr)
            }

            for (l in tempContours.indices) {
                try {
                    val value: MatOfPoint = tempContours[l]

                    val rect: Rect = Imgproc.boundingRect(value)
                    val resp = is_rect_in_a_center(xo, yo, xf, yf, cells, rect)

                    var found = resp[0] as Boolean
                    var x_cell = resp[1] as Int
                    var y_cell = resp[2] as Int

                   if(found && x_cell>0){
                       global_board[y_cell-1][x_cell-1] = " "
                   }
                } catch (e: Exception) {
                    Log.e("loop2", e.toString())
                }
            }
            
            arr  = arrayOf(xo.toInt(), yo.toInt(), xf.toInt(), yf.toInt(), cells.toInt())

            return arr

        } catch (e: Exception) {
            Log.e("EXCEPTION", e.toString())
            arr = arrayOf(0,0,0,0,0)
            return arr
        }

        return arr
    }


    fun is_rect_in_a_center(xo: Int, yo: Int, xf: Int, yf: Int, cells: Int, rect: Rect): Array<Any> {
        var is_in = false
        var x_cell = -1
        var y_cell = -1

        val w_rect = rect.width
        val h_rect = rect.height
        val x_rect = rect.x
        val y_rect = rect.y

        for (i in 0..cells) {
            for (j in 0..cells) {
                val x_center = ((j - 0.5) * (xf - xo) / cells).toInt() + xo
                val y_center = ((i - 0.5) * (yf - yo) / cells).toInt() + yo
                if (x_center >= x_rect && y_center >= y_rect && x_center <= x_rect + w_rect && y_center <= y_rect + h_rect) {
                    if (!(is_in)) {
                        is_in = true
                        x_cell = j
                        y_cell = i
                    } else {

                        x_cell = -10
                        y_cell = -10
                    }
                }
            }
        }

        return arrayOf(is_in, x_cell, y_cell)
    }


    fun resize_image_32(image: Mat): Mat {
        val width = image.width() * (32 / (image.height()).toDouble())
        val height = 32.0
        val dim = Size(width, (height).toDouble())
        val resized = Mat()
        Imgproc.resize(image, resized, dim)
        return resized
    }


    fun get_ocr(img: Mat, cant: Int): String {

        var outputDir = cacheDir.absolutePath

        val filePath = outputDir + File.separator + "image" + UUID.randomUUID().toString() + "." + "png"

        Imgcodecs.imwrite(filePath, img)
        api.setImage(File(filePath))

        var text_ocr = api.utF8Text

        return text_ocr
    }


    fun process_black_letters(image: Mat, xo: Int, yo: Int, xf: Int, yf: Int, cells: Int): Array<String> {

        val board: Mat = Mat()
        val orig: Mat = Mat()

        image.copyTo(orig)
        image.copyTo(board)

        val gray_low = 0.0
        val gray_high = 50.0
        var fill = 255

        val image_w = image.cols()
        val image_h = image.rows()

        val gray_board: Mat = Mat()
        Imgproc.cvtColor(image, gray_board, Imgproc.COLOR_BGR2GRAY)

        val mask_gs: Mat = Mat()
        inRange(gray_board, Scalar(gray_low, gray_low), Scalar(gray_high, gray_high), mask_gs)

        val letters: Mat = Mat()
        gray_board.copyTo(letters)

        Imgproc.rectangle(letters, Point(0.0, 0.0), Point(image_w.toDouble(), image_h.toDouble()), Scalar(255.0, 255.0, 255.0), Imgproc.FILLED)

        copyTo(gray_board, letters, mask_gs)

        var contours: List<MatOfPoint> = ArrayList()
        val hierarchy = Mat()

        findContours(mask_gs, contours, hierarchy, Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE)

        val w_c = (xf - xo) / cells
        val h_c = (yf - yo) / cells

        val max_height = 112
        val total_width = 32 * 225
        val padding = 5

        val out = Mat(max_height, 225 * padding + total_width, CvType.CV_8UC1)
        Imgproc.rectangle(out, Point(0.0, 0.0), Point((225 * padding + total_width).toDouble(), (max_height).toDouble()), Scalar(255.0, 255.0, 255.0), FILLED)

        var current_x: Int = 40
        var cont: Int = 0

        val cell_position: ArrayList<Array<Int>> = ArrayList()

        contours = contours.sortedBy { getContourPrecedence(it, mask_gs.width()) }

        var r = Mat()
        var resp_cnt: Int = 0

        for (l in contours.indices) {

            try {
                val value: MatOfPoint = contours[l]
                val rect: Rect = Imgproc.boundingRect(value)

                val w = rect.width
                val h = rect.height
                val x = rect.x
                val y = rect.y

                var found = false
                var x_cell = -1
                var y_cell = -1

                var wr = 0
                var hr = 0

                if (y >= yo && y <= yf && x >= xo && x <= xf) {
                    resp_cnt += 1
                    val resp = is_rect_in_a_center(xo, yo, xf, yf, cells, rect)

                    found = resp[0] as Boolean
                    x_cell = resp[1] as Int
                    y_cell = resp[2] as Int

                    if (found && x_cell > 0) {
                        cell_position.add(arrayOf(x_cell, y_cell))
                        cont += 1

                        var input = Mat()
                        input = Mat(letters, Rect(x, y, w, h))

                        r = resize_image_32(input)
                        wr = r.width()
                        hr = r.height()
                        r.copyTo(out.submat(40, 40 + hr, current_x, current_x + wr))

                        current_x += wr + padding
                    }
                }

            } catch (e: Exception) {
                Log.e("loop1", e.toString())
            }
        }

        var res_out = out.submat(0, max_height, 0, current_x + 40);
        var dis_out = Mat(res_out.width()*2, res_out.width(), CvType.CV_8UC1)
        res_out.copyTo(dis_out.submat(100, 100+res_out.height(), 0, res_out.width()))

        var status = "OK"

        // OCR
        var text_tesseract = get_ocr(res_out, resp_cnt)

        if(text_tesseract.length==cont) {

            Log.e("status","Status: OK - 1 (black chars)")
            status = "OK"

            for (i in 0..text_tesseract.length - 1) {
                global_board[cell_position[i][1] - 1][cell_position[i][0] - 1] = text_tesseract[i].toString()
            }
        }else {
            Log.e("status","Status: Error - 1 (black chars)")
            status = "Error 1"
        }

        Log.e("ocr", "OCR Black chars: : $text_tesseract")
        for(i in 0..cells-1){
            Log.e("globalboard", "${global_board[i]}")
        }

        var arr : Array<String> = arrayOf(status,text_tesseract)

        return arr

    }

    fun process_letters_to_play(image: Mat, xo: Int, yo: Int, xf: Int, yf: Int, cells: Int):String {
        var board: Mat = Mat()

        image.copyTo(board)

        var yf2 = image.height()

        val gray_low = 0
        val gray_high = 50
        val fill = 255

        val gray_board = Mat()
        val mask_gs = Mat()
        Imgproc.cvtColor(board, gray_board, COLOR_BGR2GRAY)

        inRange(gray_board, Scalar(gray_low.toDouble(), gray_low.toDouble(), gray_low.toDouble()), Scalar(gray_high.toDouble(), gray_high.toDouble(), gray_high.toDouble()), mask_gs)

        val letters = Mat()
        gray_board.copyTo(letters)


        rectangle(letters, Point(0.0, 0.0), Point(gray_board.rows().toDouble(), gray_board.cols().toDouble()), Scalar(255.0, 255.0, 255.0), Imgproc.FILLED)

        copyTo(gray_board,letters,mask_gs)

        val hierarchy = Mat()
        var contours: List<MatOfPoint> = ArrayList()

        findContours(mask_gs, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE)

        if (contours.size == 1) {
            findContours(mask_gs, contours, hierarchy, RETR_LIST, CHAIN_APPROX_SIMPLE)
        }

        val w_c = (xf - xo) / cells.toDouble()
        val h_c = (yf - yo) / cells.toDouble()

        val max_height = 112
        val total_width = 32 * 225
        val padding = 5

        val out = Mat(max_height, 225 * padding + total_width, CvType.CV_8UC1)

        Imgproc.rectangle(out, Point(0.0, 0.0), Point((225 * padding + total_width).toDouble(), (max_height).toDouble()), Scalar(255.0, 255.0, 255.0), FILLED)

        var current_x = 40
        var cont = 0

        contours = contours.sortedBy { getContourPrecedence(it, mask_gs.width()) }

        var r = Mat()

        for (l in contours.indices) {

            try {

                val value: MatOfPoint = contours[l]

                val rect: Rect = Imgproc.boundingRect(value)

                val w = rect.width
                val h = rect.height
                val x = rect.x
                val y = rect.y

                var found = false
                var x_cell = -1
                var y_cell = -1

                var wr = 0
                var hr = 0

                if (y > yf) {
                    if (h > h_c * 0.55 && w < w_c * 2 && w > w_c * 0.1 && y < yf2) {
                        cont += 1
                        var input = Mat()

                        input = Mat(letters, Rect(x, y, w, h))

                        r = resize_image_32(input)

                        wr = r.width()
                        hr = r.height()
                        yf2 = y + h

                        r.copyTo(out.submat(40, 40 + hr, current_x, current_x + wr))
                        current_x += wr + padding
                    }
                }


            } catch (e: Exception) {
                Log.e("loop7", e.toString())
            }


        }

        if (cont == 0) {
            val gray_high = 100
            val fill = 255

            val gray_board = Mat()
            val mask_gs = Mat()
            Imgproc.cvtColor(board, gray_board, COLOR_BGR2GRAY)

            inRange(gray_board, Scalar(gray_low.toDouble(), gray_low.toDouble(), gray_low.toDouble()), Scalar(gray_high.toDouble(), gray_high.toDouble(), gray_high.toDouble()), mask_gs)

            val letters = Mat()
            gray_board.copyTo(letters)

            Imgproc.rectangle(letters, Point(0.0, 0.0), Point(gray_board.rows().toDouble(), gray_board.cols().toDouble()), Scalar(255.0, 255.0, 255.0), Imgproc.FILLED)


            copyTo(gray_board, mask_gs, letters)

            val hierarchy = Mat()
            val contours: List<MatOfPoint> = ArrayList()

            findContours(mask_gs, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE)

            if (contours.size == 1) {
                findContours(mask_gs, contours, hierarchy, RETR_LIST, CHAIN_APPROX_SIMPLE)
            }

            contours.sortedBy { getContourPrecedence(it, mask_gs.width()) }


            for (l in contours.indices) {

                try {

                    val value: MatOfPoint = contours[l]

                    val rect: Rect = Imgproc.boundingRect(value)

                    val w = rect.width
                    val h = rect.height
                    val x = rect.x
                    val y = rect.y

                    var found = false
                    var x_cell = -1
                    var y_cell = -1

                    var wr = 0
                    var hr = 0

                    if (y > yf) {
                        if (h > h_c * 0.55 && w < w_c * 2 && w > w_c * 0.1 && y < yf2) {
                            cont += 1

                            var input = Mat()
                            input = Mat(letters, Rect(x, y, w, h))

                            r = resize_image_32(input)

                            wr = r.width()
                            hr = r.height()
                            yf2 = y + h

                            r.copyTo(out.submat(40, 40 + hr, current_x, current_x + wr))
                            current_x += wr + padding
                        }
                    }


                } catch (e: Exception) {
                    Log.e("loop6", e.toString())
                }


            }
        }


        var res_out = out.submat(0, max_height, 0, current_x + 40);

        var status = "OK"

        var text_tesseract = get_ocr(res_out, cont)

        val position = Point(20.0, 100.0)
        val color = Scalar(0.0, 0.0, 0.0)
        val font = Imgproc.FONT_HERSHEY_SIMPLEX
        val scale = 1.0
        val thickness = 3

        var whiteImage: Mat = Mat()
        gray_board.copyTo(whiteImage)

        Imgproc.rectangle(whiteImage, Point(0.0, 0.0), Point(gray_board.width().toDouble(), gray_board.height().toDouble()), Scalar(255.0, 255.0, 255.0), Imgproc.FILLED)


        Imgproc.putText(whiteImage, text_tesseract, position, font, scale, color, thickness)


        return text_tesseract
    }


    fun process_white_letters(image: Mat, xo: Int, yo: Int, xf: Int, yf: Int, cells: Int): String {

        val hsv_board = Mat()
        val gray_board = Mat()
        val img = Mat()
        cvtColor(image, hsv_board, COLOR_BGR2HSV)
        cvtColor(image, gray_board, COLOR_BGR2GRAY)

        image.copyTo(img)
        val w_c = (xf - xo) / cells.toDouble()
        val h_c = (yf - yo) / cells.toDouble()

        val max_height = 112
        val total_width = 32 * 225
        val padding = 5

        lateinit var out:Mat
        try {
            out = Mat(max_height, 225 * padding + total_width, CvType.CV_8UC1)
        }catch (e:java.lang.Exception){
            Log.e("exception","its at out")
        }

        rectangle(out, Point(0.0, 0.0), Point((225 * padding + total_width).toDouble(), (max_height).toDouble()), Scalar(255.0, 255.0, 255.0), FILLED)

        var current_x = 40
        var cont = 0
        val cell_position: ArrayList<Array<Int>> = ArrayList()
        var blank_cell = true
        var r = Mat()
        for (i in 0..cells-1) {

            for (j in 0..cells-1) {
                if (global_board[i][j] == "-") {
                    blank_cell = true

                    val x_from = xo + (j * w_c).toInt()
                    val y_from = yo + (i * h_c).toInt()
                    val x_to = xo + ((j + 1) * w_c).toInt()
                    val y_to = yo + ((i + 1) * h_c).toInt()
                    var gray_cell  = Mat()
                    gray_cell = gray_board.submat(y_from, y_to, x_from, x_to)

                    val mask_white = Mat()
                    inRange(gray_cell, Scalar(240.0, 240.0, 240.0), Scalar(255.0, 255.0, 255.0), mask_white)

                    var hsv_cell = Mat()
                    hsv_cell = hsv_board.submat(y_from, y_to, x_from, x_to)

                    val mask_hsv = Mat()
                    inRange(hsv_cell, Scalar(98.0, 50.0, 150.0), Scalar(110.0, 200.0, 255.0), mask_hsv)

                    val ww = x_to - x_from
                    val hh = y_to - y_from
                    val x_center = (ww / 2).toInt()
                    val y_center = (hh / 2).toInt()

                    val hierarchy = Mat()
                    val contours: List<MatOfPoint> = ArrayList()

                    findContours(mask_white, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_NONE)

                    for (l in contours.indices) {

                        try {

                            val value: MatOfPoint = contours[l]

                            val rect: Rect = Imgproc.boundingRect(value)

                            val w = rect.width
                            val h = rect.height
                            val x = rect.x
                            val y = rect.y

                            if (x_center >= x && y_center >= y && x_center <= x + w && y_center <= y + h && w.toDouble() / ww < 0.85 && h.toDouble() / hh < 0.85 && h.toDouble() / hh > 0.40 && contourArea(value) / (w * h).toDouble() > 0.28) {
                                cont += 1

                                var input = Mat()
                                var finalInput = Mat()

                                try {
                                    input = Mat(mask_white, Rect(x, y, w, h))

                                }catch (e:java.lang.Exception){
                                    Log.e("exception","at input creation")
                                }

                                try {
                                    Core.subtract(MatOfDouble(255.0), input, finalInput)
                                }catch (e:java.lang.Exception){
                                    Log.e("exception","at subtract")
                                }
                                r = resize_image_32(finalInput)

                                var wr = r.width()
                                var hr = r.height()

                                cell_position.add(arrayOf(j, i))

                                try {
                                    r.copyTo(out.submat(40, 40 + hr, current_x, current_x + wr))
                                }catch (e:java.lang.Exception){
                                    Log.e("exception","at out put submat")
                                }
                                current_x += wr + padding
                                blank_cell = false
                            }

                        } catch (e: Exception) {
                            Log.e("loop5", e.toString())
                        }
                    }

                    if (blank_cell) {
                        findContours(mask_hsv, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_NONE)

                        for (l in contours.indices) {

                            try {

                                val value: MatOfPoint = contours[l]

                                val rect: Rect = Imgproc.boundingRect(value)

                                val w = rect.width
                                val h = rect.height
                                val x = rect.x
                                val y = rect.y
                                if (x_center >= x && y_center >= y && x_center <= x + w && y_center <= y + h && w / ww.toDouble() < 0.85 && h / hh.toDouble() < 0.85 && h / hh.toDouble() > 0.40 && contourArea(value) / (w * h).toDouble() > 0.28) {
                                    cont += 1

                                    var input = Mat()
                                    var finalInput = Mat()
                                    try{
                                        input = Mat(mask_hsv, Rect(x,y,w,h))
                                    }catch (e:java.lang.Exception){
                                        Log.e("exception","at input creation")
                                    }

                                    Core.subtract(MatOfDouble(255.0), input, finalInput)
                                    r = resize_image_32(finalInput)

                                    var wr = r.width()
                                    var hr = r.height()
                                    cell_position.add(arrayOf(j, i))
                                    r.copyTo(out.submat(40, 40 + hr, current_x, current_x + wr))
                                    current_x += wr + padding
                                    blank_cell = false
                                }

                            } catch (e: Exception) {
                                Log.e("loop4", e.toString())
                            }


                        }
                    }

                    if (blank_cell) {
                        global_board[i][j] = " "
                    }
                }
            }
        }


        val res_out = out.submat(0, max_height, 0, current_x + 40);
        var dis_out = Mat(res_out.width()*2, res_out.width(), CvType.CV_8UC1)
        res_out.copyTo(dis_out.submat(100, 100+res_out.height(), 0, res_out.width()))

        var status = "OK"

        val text_tesseract = get_ocr(res_out, cont)

        if (text_tesseract.length == cont){
            Log.e("OCRWhite","Status: OK - 3 (white chars)")
            status = "OK"

            for (i in 0..text_tesseract.length-1) {
                global_board[cell_position[i][1]][cell_position[i][0]] = text_tesseract[i].toString()
            }

        }else {
            status = "Error 3"
            Log.e("OCRWhite","Status: Error - 3 (white chars)")
        }

        Log.e("OCRWhite","OCR White chars : $text_tesseract")

        return text_tesseract

    }



    override fun onResume() {
        super.onResume()
        if (!OpenCVLoader.initDebug()) {
            Log.d("OpenCV", "Internal OpenCV library not found. Using OpenCV Manager for initialization")
            OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_0_0, this, mLoaderCallback)
        } else {
            Log.d("OpenCV", "OpenCV library found inside package. Using it!")
            mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS)
        }
    }


    private val mLoaderCallback: BaseLoaderCallback = object : BaseLoaderCallback(this) {
        override fun onManagerConnected(status: Int) {
            when (status) {
                LoaderCallbackInterface.SUCCESS -> {
                    Log.i("OpenCV", "OpenCV loaded successfully")
                    //imageMat = Mat()
                }
                else -> {
                    super.onManagerConnected(status)
                }
            }
        }
    }
}