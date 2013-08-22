package tablingassigner;
import java.util.*;
import java.io.*;

public class TablingSettings {

    public static HashSet enumerateTablingSlots() {
        File tsFile = new File(_TABLING_SCHEDULE_FILE);
        BufferedReader reader = null;
        HashSet<TablingSlot> tsSet = null;

        try {
            reader = new BufferedReader(new FileReader(tsFile));
            tsSet = new HashSet<TablingSlot>();

            String line = null;
            while ((line=reader.readLine()) != null) {
                String delimiter = ",";
                String[] startTimes = line.split(delimiter);
                int dowIndicator = 0;

                DayOfWeek dow = null;
                for (DayOfWeek dowVal : DayOfWeek.values()) {
                    if (startTimes[dowIndicator].equals(dowVal.toString())) {
                        dow = dowVal;
                    }
                }

                for (int i=1; i<startTimes.length-1; i++) {
                    tsSet.add(new TablingSlot(dow,Integer.parseInt(startTimes[i]),new Time(
                                (new Time(Integer.parseInt(startTimes[i]))).getReal() +
                                    TablingSlot.slotLength().getReal()).getLiteral()));
                }
            }
        }
        catch (IOException e) {
            System.err.println(e);
            System.exit(1);
        }

        return tsSet;
    }

    private static HashSet<TablingSlot> _tsSet = new HashSet<TablingSlot>();
    private static final String _TABLING_SCHEDULE_FILE = "tabling_schedule.csv";
}
