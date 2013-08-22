package tablingassigner;

import java.io.*;
import java.util.*;

/**
 * Parser for emailed Telebear schedules.
 *
 * @author Keien Ohta, Mimi Tam
 */

public class TelebearsParser {
    public static void main(String[] args) {
        String inputFileName = args[0];
        String scheduleFileName = "schedules.csv";
        String studentFileName = "members.csv";

        File inFile  = new File(inputFileName);
        File studentFile = new File(studentFileName);
        File scheduleFile = new File(scheduleFileName);

        BufferedReader reader = null;
        BufferedWriter studentWriter = null;
        BufferedWriter scheduleWriter = null;

        try {
            reader = new BufferedReader(new FileReader(inputFileName));
            studentWriter = new BufferedWriter(new FileWriter(studentFileName));
            scheduleWriter = new BufferedWriter(new FileWriter(scheduleFileName));

            String line = null;

            String name = null;
            int SSID = -1;
            Position pos = null;
            String dow = "";
            int startTime = -1;
            int endTime = -1;
            int startDate = 20130122;
            int endDate = 20130514;
            int ccn = -1;

            String ccnRegex = "[0-9]+";
            String dowRegex = "\\-[\\-M][\\-T][\\-W][\\-T][\\-F]\\-";
            String newStudent = "---new---";
            String timeRegex = "[0-2][0-9]:[0,3]0[A,P]?M?\\s\\-\\s[0-2][0-9]:[0,3]0[A,P]M";

            while ((line=reader.readLine()) != null) {
                if (line.matches(newStudent)) {
                    name = reader.readLine();
                    String posStr = reader.readLine();
                    if (posStr.equalsIgnoreCase("cm")) {
                        pos = Position.CM;
                    }
                    else if (posStr.equalsIgnoreCase("chair")) {
                        pos = Position.CHAIR;
                    }
                    else if (posStr.equalsIgnoreCase("exec")) {
                        pos = Position.EXEC;
                    }
                    SSID++;

                    studentWriter.write(SSID + "," + name + "," + pos.val());
                    studentWriter.newLine();
                }
                else if (line.matches(ccnRegex)) {
                    ccn = Integer.parseInt(line);
                }
                else if (line.matches(dowRegex)) {
                    dow = line.substring(1, line.length()-1);
                }
                else if (line.matches(timeRegex)) {
                    startTime = Integer.parseInt(line.substring(0,2) + line.substring(3,5));
                    int end = line.length();
                    endTime = Integer.parseInt(line.substring(end-7,end-5) + line.substring(end-4,end-2));
                    if (line.substring(end-2, end).equals("PM") && endTime < 1200) {
                        if (startTime < endTime) startTime += 1200;
                        endTime += 1200;
                    }

                    if (ccn != -1) {
                        /* if (ccn==11111) System.out.println(name + "," + dow + "," + startDate + "," + endDate +
                            "," + startTime + "," + endTime); */
                        scheduleWriter.write(SSID + "," + dow + "," + startDate + "," + endDate +
                            "," + startTime + "," + endTime);
                        scheduleWriter.newLine();
                    }
                    ccn = -1;
                }
            }
            studentWriter.close();
            scheduleWriter.close();
        }
        catch (IOException e) {
            System.err.println(e);
            System.exit(1);
        }
    }
}
