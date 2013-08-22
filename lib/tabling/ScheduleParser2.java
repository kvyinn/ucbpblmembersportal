package tablingassigner;

import java.io.*;
import java.util.*;

/**
 * Parser for reading test data containing Telebear schedules
 * (for testing purposes only)
 *
 * java ScheduleParser2 [input file]
 *
 * @author Keien Ohta
 */

public class ScheduleParser2 {
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

            int SSID = -1;
            Position pos = null;
            String dow = "";
            int startTime = -1;
            int endTime = -1;
            int startDate = 20130122;
            int endDate = 20130514;

            String ccnRegex = "[0-9]+";
            String dowRegex = "[\\-M][\\-T][\\-W][\\-T][\\-F]";
            String endTimeRegex = "\\-[0-2][0-9][0,3]0";

            while ((line=reader.readLine()) != null) {

                String[] tokens = line.split("\\s+");

                if (tokens[0].matches(ccnRegex)) {
                    int i = 0;
                    for (String token : tokens) {
                        if (token.matches(dowRegex)) {
                            dow = token;
                        }
                        else if (token.matches(endTimeRegex)) {
                            startTime = Integer.parseInt(tokens[i-1]);
                            endTime = Integer.parseInt(token.substring(1,5));
                            if (tokens[i+1].equals("PM") && endTime < 1200) {
                                if (startTime < endTime) startTime += 1200;
                                endTime += 1200;
                            }
                        }
                        i++;
                    }

                    scheduleWriter.write(SSID + "," + dow + "," + startDate + "," + endDate +
                        "," + startTime + "," + endTime);
                    scheduleWriter.newLine();
                }
                else if (tokens.length > 1) {
                    SSID += 1;
                    String posStr = tokens[tokens.length-1];
                    if (posStr.equals("CM")) {
                        pos = Position.CM;
                    }
                    else if (posStr.equals("chair")) {
                        pos = Position.CHAIR;
                    }
                    else if (posStr.equals("exec")) {
                        pos = Position.EXEC;
                    }

                    studentWriter.write(SSID + "," + pos);
                    studentWriter.newLine();
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
