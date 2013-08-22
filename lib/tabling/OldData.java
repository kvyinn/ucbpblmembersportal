/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduleparser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author hiralmehta
 */
public class OldData {

    public static void main(String... args) {
        FileInputStream fis = null;
        try {
            File f = new File("src/scheduleparser/data_full.txt");
            fis = new FileInputStream(f);
            InputStreamReader isr = new InputStreamReader(fis);
            BufferedReader br = new BufferedReader(isr);

            boolean b = f.exists();
            
            File temp = new File("src/scheduleparser/temp.txt");
            while (true) {
                String next = br.readLine();
                if (next == null)
                    break;
                
                String[] s = next.split(" ");
                String name = s[0] + " " + s[1];
                String committee = s[2];
                String position = s[3];

                FileWriter fw = new FileWriter(temp, false);

                next = br.readLine();
                if (next == null)
                    break;
                while (!next.equals("")) {
                    if (next.startsWith("0 ")) {
                        next = br.readLine();
                        if (next == null)
                            break;
                        continue;
                    }
                    fw.write(next);
                    fw.write("\n");
                    next = br.readLine();
                    if (next == null)
                        break;
                }
                fw.close();


                try {
                ScheduleParser.main(new String[]{"src/scheduleparser/temp.txt", "src/scheduleparser/schedules.xml", name, committee, position});
                } catch (ArrayIndexOutOfBoundsException e) {
                }
            }
            
            
        }  catch (FileNotFoundException ex) {
        } catch (IOException e) {
        }
    }
}
