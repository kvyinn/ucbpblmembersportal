/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduleparser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/** 
 * The input file with the adob information must have the following tags if
 * the time range is one of the ones in parenthesis.
 * -sd [StartDate or SingleDate] (range, day)
 * -ed [EndDate] (range)
 * -d [Days] (range, perpetual)
 * -t [Time] (day, range, perpetual)
 * 
 * The description must be present on the next line.
 * @author hiralmehta
 */
public class AdObAdder {

    public static void addAdOb(ParserSettings settings) throws IOException {

        String inputSourcePath = settings.inputFile();
        String xmlFilePath = settings.schedulesFile();
        String name = settings.name();
        String committee = settings.committee();
        String position = settings.position();

        Document xmlDoc = ScheduleParser.getDocument(xmlFilePath);


        Node student = ScheduleParser.getStudent(xmlDoc, name, committee, position);

        File f = new File(inputSourcePath);
        FileInputStream fis = new FileInputStream(f);
        InputStreamReader isr = new InputStreamReader(fis);
        BufferedReader br = new BufferedReader(isr);
        String nextLine = br.readLine();
        String[] adobComponents = nextLine.split(" ");

        if (!adobComponents[0].equals("adob")) {
            throw new IllegalArgumentException("File is not an adob.");
        }
        Element adob = xmlDoc.createElement("AdOb");

        Element time = xmlDoc.createElement("Time");
        time.setTextContent(normalizeTime(findTime(adobComponents)));
        adob.appendChild(time);

        Element description = xmlDoc.createElement("Description");
        description.setTextContent(br.readLine());
        adob.appendChild(description);

        String range = adobComponents[1];
        if (range.equals("day")) {

            adob.setAttribute("range", "day");



            Element date = xmlDoc.createElement("Date");
            date.setTextContent(findSingleDate(adobComponents));
            adob.appendChild(date);

        } else if (range.equals("range")) {
            //Element adob = xmlDoc.createElement("AdOb");
            adob.setAttribute("range", "range");


            Element startDate = xmlDoc.createElement("StartDate");
            startDate.setTextContent(findStartDate(adobComponents));
            adob.appendChild(startDate);

            Element endDate = xmlDoc.createElement("EndDate");
            endDate.setTextContent(findEndDate(adobComponents));
            adob.appendChild(endDate);

            Element days = xmlDoc.createElement("Days");
            days.setTextContent(findDays(adobComponents));
            adob.appendChild(days);

        } else if (range.equals("perpetual")) {
            //Element adob = xmlDoc.createElement("AdOb");
            adob.setAttribute("range", "perpetual");

            Element days = xmlDoc.createElement("Days");
            days.setTextContent(findDays(adobComponents));
            adob.appendChild(days);


        } else {
            throw new IllegalArgumentException("Adob type is not correctly specified. Must be 'range', 'day', or 'perpetual'");
        }

        student.appendChild(adob);


        ScheduleParser.writeXmlFile(xmlDoc, xmlFilePath);

    }

    private static String findTime(String[] components) {
        return findComponent("-t", components);
    }

    private static String findStartDate(String[] components) {
        return findComponent("-sd", components);
    }

    private static String findEndDate(String[] components) {
        return findComponent("-ed", components);
    }

    private static String findDays(String[] components) {
        return findComponent("-d", components);
    }

    private static String findSingleDate(String[] components) {
        return findComponent("-sd", components);
    }

//    private static String findDescription(String[] components) {
//        for (int i = 0; i < components.length, i++) {
//            if (components[i].equals("-desc")) {
//                String d = "";
//                for (int j = i + 1; j < components.length; j++) {
//                    d += components[j];
//                    if (components[j].endsWith("\"")) {
//                        break;
//                    }
//                }
//                return d.substring(i)
//            }
//        }
//        
//    }

    private static String findComponent(String flag, String[] components) {
        for (int i = 0; i < components.length; i++) {
            if (components[i].equals(flag)) {
                return components[i + 1];
            }
        }
        throw new IllegalArgumentException(flag + " was not provided.");
    }

    /**
     * 
     * @param time e.g. 11:00AM-01:00PM
     * @return 
     */
    private static String normalizeTime(String time) throws IOException {
        Pattern p = Pattern.compile("([0-9]{2})[:\\s]?([03]0).*([0-9]{2})[:\\s]?([03]0).*([AP]M)");
        Matcher m = p.matcher(time);
        if (!m.matches()) {
            throw new IOException("Error reading class hours " + time);
        }
        //for (int i = 0; i < m.groupCount() + 1; i++) {
        //    System.out.println(m.group(i));
        //}
        if (m.group(5).equals("AM")) {
            return m.group(1) + m.group(2) + "-" + m.group(3) + m.group(4);
        } else { // m.group(5).equals("PM")
            if (m.group(3).equals("12")) {
                return m.group(1) + m.group(2) + "-" + m.group(3) + m.group(4);
            } else if (Integer.valueOf(m.group(3)) > Integer.valueOf(m.group(1))) {
                return (Integer.valueOf(m.group(1)) + 12) + m.group(2) + "-" + (Integer.valueOf(m.group(3)) + 12) + m.group(4);

            } else {
                return m.group(1) + m.group(2) + "-" + (Integer.valueOf(m.group(3)) + 12) + m.group(4);
            }
        }
    }
}
