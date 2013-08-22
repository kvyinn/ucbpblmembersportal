/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduleparser;

import java.io.BufferedReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/**
 *
 * @author hiralmehta
 */
public class ScheduleParser {

    /**
     * inputSourcePath xmlFilePath name committee position
     * -delete [id] // TODO implement.
     * -list {detailed} {chairs,execs,officers,cms,all} //todo
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        //TODO: Concurrency handing!
        try {
            /*
            String inputSourcePath = "src/scheduleparser/file.txt";
            String xmlFilePath = "src/scheduleparser/scheduless.xml";
            String name = "Rohin Jethani";
            String committee = "EX";
             */
            ParserSettings settings = ParserSettings.parseArgs(args);

            if (settings.function() == ParserSettings.ParserFunction.ADD_SCHED) {
                addSchedule(settings);
            } else if (settings.function() == ParserSettings.ParserFunction.ADD_ADOB) {
                AdObAdder.addAdOb(settings);
            }

//
//        } catch (FileNotFoundException e) {
//            System.out.println("ERROR: File not found: " + e.getMessage());
        } catch (IOException e) {
            System.out.println("ERROR: " + e.getMessage());
        }
    }

    private static void addSchedule(ParserSettings settings) throws IOException {

        String inputSourcePath = settings.inputFile();
        String xmlFilePath = settings.schedulesFile();
        String name = settings.name();
        String committee = settings.committee();
        String position = settings.position();

        Document xmlDoc = getDocument(xmlFilePath);


        Element student = (Element) getStudent(xmlDoc, name, committee, position);

        NodeList nl = student.getElementsByTagName("AdOb");

        Node[] a = new Node[nl.getLength()];

        for (int i = 0; i < nl.getLength(); i++) {
            a[i] = nl.item(i).cloneNode(true);
        }
//            
//            Node student = getStudent(xmlDoc, name, committee, position);
//            
//            NodeList nl = student.getChildNodes();
//            
//            for (int i = 0; i < nl.getLength(); i++) {
//                String s = nl.item(i).getNodeName();
//                if (s.equals("Course")) {
//                    student.removeChild(nl.item(i));
//                }
//            }


        while (student.hasChildNodes()) {
            student.removeChild(student.getFirstChild());
        }

        for (Node n : a) {
            student.appendChild(n);
        }

        File f = new File(inputSourcePath);
        FileInputStream fis = new FileInputStream(f);
        InputStreamReader isr = new InputStreamReader(fis);
        BufferedReader br = new BufferedReader(isr);
        String nextLine = br.readLine();


        /* While there are lines to read in the telebears schedule. */
        while (nextLine != null) {
            /* All classes begin with a 5 digit CCN. */
            if (nextLine.matches("[0-9]{5}.*")) {
                String[] classDetails = nextLine.split("\\s*(\\t|\\s{2,})\\s*");



                //String status;
                //String section;
                //String location;
//                    try {
//                        status = findStatus(classDetails);
//                    } catch (IOException e) {
//                        status = "";
//                    }

                /* If this is a dropped class, ignore it. */
                try {
                    if (findStatus(classDetails).equals("Instr Drop")) {
                        nextLine = br.readLine();
                        continue;
                    }
                } catch (IOException e) {
                }

                boolean unsched = false;
                for (String s : classDetails) {
                    if (s.equals("UNSCHED")) {
                        unsched = true;
                    }
                }
                if (unsched) {
                    nextLine = br.readLine();
                    continue;
                }


//                    try {
//                        section = findSection(classDetails);
//                    } catch (IOException e) {
//                        section = "";
//                    }

//                    try {
//                        location = findLocation(classDetails);
//                    } catch (IOException e) {
//                        location = "";
//                    }







                // Create the Class Element for this.
                Element classElt = xmlDoc.createElement("Course");


                /* These are the three required parts of each course */
                String ccn = findCCN(classDetails);
                Element ccnElt = xmlDoc.createElement("CCN");
                ccnElt.setTextContent(ccn);
                classElt.appendChild(ccnElt);

                String days = findDays(classDetails);
                Element daysElt = xmlDoc.createElement("Days");
                daysElt.setTextContent(days);
                classElt.appendChild(daysElt);

                String time = findTime(classDetails);
                time = normalizeTime(time);
                Element timeElt = xmlDoc.createElement("Time");
                timeElt.setTextContent(time);
                classElt.appendChild(timeElt);

                /* These remaining parts are not required, and so 
                 * if its unable to find it, we move on.
                 */
                try {
                    String courseName = findClass(classDetails);
                    Element courseNameElt = xmlDoc.createElement("CourseName");
                    courseNameElt.setTextContent(courseName);
                    classElt.appendChild(courseNameElt);
                } catch (IOException e) {
                }

                try {
                    String section = findSection(classDetails);
                    Element sectionElt = xmlDoc.createElement("Section");
                    sectionElt.setTextContent(section);
                    classElt.appendChild(sectionElt);
                } catch (IOException e) {
                    // If it cant find the section, don't add the tag.
                }



                try {
                    String status = findStatus(classDetails);
                    Element statusElt = xmlDoc.createElement("Status");
                    statusElt.setTextContent(status);
                    classElt.appendChild(statusElt);
                } catch (IOException e) {
                }

                try {
                    String location = findLocation(classDetails);
                    Element locationElt = xmlDoc.createElement("Location");
                    locationElt.setTextContent(location);
                    classElt.appendChild(locationElt);
                } catch (IOException e) {
                }

                // Add the Class Element to the Student Element
                student.appendChild(classElt);

            }
            nextLine = br.readLine();
        }



        writeXmlFile(xmlDoc, xmlFilePath);
    }

//    private void addAdOb(ParserSettings settings) {
//                    String inputSourcePath = settings.inputFile();
//            String xmlFilePath = settings.schedulesFile();
//            String name = settings.name();
//            String committee = settings.committee();
//            String position = settings.position();
//            
//            
//    }
    /** Gets the XML Document from the file and makes sure at the root element
     * is a <Schedules> tag.
     * @param file The filepath of the file to get the document of
     * @return The file document with the <Schedules> root element.
     */
    public static Document getDocument(String file) throws IOException {

        File f = new File(file);
        Document doc = isValidXML(f);
        if (doc == null) {
            try {
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                DocumentBuilder db = dbf.newDocumentBuilder();
                doc = db.newDocument();
                doc.appendChild(doc.createElement("Schedules"));
            } catch (ParserConfigurationException ex) {
                throw new IOException("Error in parsing XML file.");
            }
        }
        return doc;


    }

    /** Checks if the file is a valid XML file, and that the root Element is
     * a <Schedules> tag.
     * 
     * @param f The file to check.
     * @return If its valid, this returns the parsed DOM Document. If not
     * this returns null.
     */
    private static Document isValidXML(File f) {
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(f);

            if (!doc.getDocumentElement().getTagName().equals("Schedules")) {
                return null;
            }

            return doc;

        } catch (SAXException ex) {
            return null;
        } catch (IOException ex) {
            return null;
        } catch (ParserConfigurationException ex) {
            return null;
        }

    }

    /**Gets the student with the given name and committee in the schedulesDoc
     * document. If the student already exists in the document then it will return
     * that node, if not it'll create a new node and add it into the document.
     * NOTE: If two students have the same name, and are in the same committee,
     * then this will overwrite their schedules. Some modification to their name
     * MUST be made in order for any of this to work properly.
     * @param schedulesDoc The XML Document that contains all the student schedules.
     * @param name The name of the student to get.
     * @param committee The TWO LETTER committee abbreviation for the
     * committee the student is in.
     * @return 
     */
    public static Node getStudent(Document schedulesDoc, String name, String committee, String position) {
        Element schedules = schedulesDoc.getDocumentElement();
        NodeList students = schedules.getElementsByTagName("Student");
        for (int i = 0; i < students.getLength(); i++) {
            /* If the an entry in student in SCHEDULES with the same name and 
             * committee already exists, then return that student.
             */
            if (students.item(i).getAttributes().getNamedItem("name").getNodeValue().equals(name)
                    && students.item(i).getAttributes().getNamedItem("committee").getNodeValue().equals(committee)) {
                return students.item(i);
            }
        }
        /* If no student with that name and committe exists, then create a new
         * Node, add it to the document, and return the node.
         */
        Element newStudent = schedulesDoc.createElement("Student");
        newStudent.setAttribute("name", name);
        newStudent.setAttribute("committee", committee);
        newStudent.setAttribute("position", position);
        schedules.appendChild(newStudent);
        return newStudent;
    }

    public static void writeXmlFile(Document doc, String filename) throws IOException {
        try {
            // Prepare the DOM document for writing
            Source source = new DOMSource(doc);

            // Prepare the output file
            File file = new File(filename);
            Result result = new StreamResult(file);

            // Write the DOM document to the file
            TransformerFactory tf = TransformerFactory.newInstance();
            tf.setAttribute("indent-number", new Integer(2));
            Transformer xformer = tf.newTransformer();
            xformer.setOutputProperty(OutputKeys.INDENT, "yes");
            xformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "3");
            xformer.transform(source, result);
        } catch (TransformerConfigurationException e) {
            throw new IOException("Error writing to XML file.");
        } catch (TransformerException e) {
        }
    }

    public static String normalizeTime(String time) throws IOException {
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

    private static String findCCN(String[] line) throws IOException {
        try {
            return findClassComponent(line, "[0-9]{5}");
        } catch (IOException e) {
            // for debugging.
            throw new IOException("Error matching CCN to " + toString(line));
        }
    }

    private static String findClass(String[] line) throws IOException {
        try {

            return findClassComponent(line, "([A-Z&]+\\s)+[A-Z]*[0-9O]+[A-Z]*").replace('&', 'n');
        } catch (IOException ex) {
            throw new IOException("Error matching Class to " + toString(line));

        }
    }

    private static String findTime(String[] line) throws IOException {
        try {
            return findClassComponent(line, "([0-9]{2})[:\\s]?([03]0).*([0-9]{2})[:\\s]?([03]0).*([AP]M)");
        } catch (IOException ex) {
            throw new IOException("Error matching TIME to " + toString(line));

        }
    }

    private static String findDays(String[] line) throws IOException {
        try {
            return findClassComponent(line, "[M-][T-][W-][T-][F-]");
        } catch (IOException ex) {
            throw new IOException("Error matching DAYS to " + toString(line));

        }
    }

    private static String findLocation(String[] line) throws IOException {
        try {
            return findClassComponent(line, "[A-Z]*[0-9]{4}(\\s[A-Z]+)+");
        } catch (IOException ex) {
            throw new IOException("Error matching LOCATION to " + toString(line));

        }
    }

    private static String findStatus(String[] line) throws IOException {
        try {
            return findClassComponent(line, "(Enrolled)||(Pending)||(Instr Drop)");
        } catch (IOException ex) {
            throw new IOException("Error matching STATUS to " + toString(line));

        }
    }

    private static String findSection(String[] line) throws IOException {
        try {
            return findClassComponent(line, "[0-9O]{2,3}\\s?((GRP)||(Sem)||(LEC)||(LAB)||(DIS))");
        } catch (IOException ex) {
            throw new IOException("Error matching SECTION to " + toString(line));
        }
    }

    private static String findClassComponent(String[] line, String regex) throws IOException {
        for (String s : line) {
            if (s.matches(regex)) {
                return s;
            }
        }
        throw new IOException();
    }

    private static String toString(String[] line) {
        String result = "[" + line[0];
        for (String s : line) {
            result += ", " + s;
        }
        return result + "]";

    }
}
