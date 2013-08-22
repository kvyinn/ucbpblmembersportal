/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package scheduleparser;

import java.util.Arrays;
import java.util.Hashtable;

/** 
 * add adob [args]
 * add schedule [args]
 * delete [id]
 * list [-n, -c, -p]
 * 
 * -n [name] (req:add, delete, list)
 * -c [committee] (req:add, delete, list)
 * -p [position] (req:add, delete, list)
 * -pending (list, delete)
 * -i [input file] (req:add)
 * -s [schedules file] (req:add)
 * -o [output file] (list, default: print to console)
 * 
 * adob
 * -r [day/range/perpetual]
 * -sd [startDate or singleDate]
 * -ed [endDate]
 * -d [days] (e.g. M-W-F)
 * 
 * 
 * @author Rohin Jethani
 */
public class ParserSettings {
    
    public static ParserSettings parseArgs(String[] args) {
        if (args.length == 0) {
            throw new IllegalArgumentException("Must provide a function to Parser Settings.");
        }
        ParserFunction func;
        if (args[0].matches("[Aa]dd")) {
            if (args[1].matches("[Ss]chedule")) {
                func = ParserFunction.ADD_SCHED;
            } else if (args[1].matches("[Aa][Dd][Oo][Bb]")) {
                func = ParserFunction.ADD_ADOB;
            } else {
                throw new IllegalArgumentException("Add must be followed by 'schedule', or 'adob'");
            }
        } else if (args[0].matches("[Dd]elete")) {
            func = ParserFunction.DELETE;
        } else if (args[0].matches("[Ll]ist")) {
            func = ParserFunction.LIST;
        } else {
            throw new IllegalArgumentException(args[0] + " is not a valid function name. Must be either 'add', 'delete' or 'list'.");
        }
        ParserSettings settings = new ParserSettings(func, parseArgsDict(args));
        return settings;
    }
    
    private static Hashtable<String, String> parseArgsDict(String[] args) {
        Hashtable<String, String> flagDict = new Hashtable<String, String>();
        
        for (int i = 0; i < args.length; i++) {
            if (args[i].charAt(0) == '-') {
                if (i + 1 < args.length && args[i+1].charAt(0) != '-') {
                    flagDict.put(args[i].substring(1), args[i+1]);
                } else {
                    flagDict.put(args[i].substring(1), null);
                }
            }
        }
        
        return flagDict;
    }
    
    protected ParserSettings(ParserFunction func, Hashtable<String, String> flagDict) {
        _func = func;
        _flagDict = flagDict;
        
        if (func == ParserFunction.ADD_SCHED || func == ParserFunction.ADD_ADOB) {
            if (!flagDict.keySet().containsAll(Arrays.asList("n", "p", "c", "i", "s"))) {
                throw new IllegalArgumentException("add function must contain the following flags: -n, -p, -c, -i, -s");
            }
        }
        
        // TODO add more error checks here.
    }
    
    public ParserFunction function() {
        return _func;
    }
    
    public String name() {
        return _flagDict.get("n");
    }
    
    public String committee() {
        return _flagDict.get("c");
    }
    
    public String position() {
        return _flagDict.get("p");
    }
    
    public String inputFile() {
        return _flagDict.get("i");
    }
    
    public String outputFile() {
        return _flagDict.get("o");
    }
    
    public String schedulesFile() {
        return _flagDict.get("s");
    }
    
    /** The id the user wants the delete.
     * This is only meaningful if the function is DELETE.
     * @return 
     */
    public int deleteId() {
        return _deleteId;
    }
    
    
    
    /** Whether or not the -pending tag is present. Only meaningful if function is LIST.
     * @return TRUE if the -pending tag is present. FALSE otherwise.
     */
    public boolean pending() {
       //TODO
        return true;
    }
    
    
    public enum ParserFunction {
        ADD_SCHED, ADD_ADOB, DELETE, LIST
    }
    
    private ParserFunction _func;
    
    private Hashtable<String, String> _flagDict;
    
    private int _deleteId;
    
    
}
