package adInterfaceWriter;

/**
 * This is the driver class in ADInterfaceWriter. 
 * It is used to call the C-function in the .dll to write 
 * data into the analog digital interface.
 *
 * @author Thierry Nouidui
 * @version 1.0
 */

public class ADInterfaceWriter {
	/**
	 * This is the main routine that starts the program.
	 * 
	 */
	public static void main(String[] args) {
		// check the length of the arguments
		if (args.length != 5) {
            printUsage();
            System.exit(1);
        }
		// define a new object of the class ReadChannel
		ADInterface converter = new ADInterface();

		try {
			int boardnumber    = getInteger(args[0]);
			int channelnumber  = getInteger(args[1]);
			int channelgain    = getInteger(args[2]);
			float channelvalue = getFloat(args[3]);
			int channeloptions = getInteger(args[4]);
			/**These are the common parameters used to read board number 0 
			 * int boardnumber = 0; int channelnumber = 0; int channelgain = 3; float channelvalue =
			 * 0; int channeloptions = 0;
			 */

			float UDWrite = 0;
			// call the C-function to write the data from the channel
			UDWrite = converter.cbVOut(boardnumber, channelnumber, channelgain, channelvalue,
					channeloptions);
			// print the result
			System.out.print(UDWrite);

		} 
		catch (Exception e) {
			System.err.println("Error in read parameters data.");
            System.err.println(e.getMessage());
			System.exit(1);
		}	
	}

	/**
	 * This method converts a string in a float.
	 * 
	 * @param number
	 *            string value.
	 * 
	 * @return float value.
	 */
	static float getFloat(String number) {

		float retNumber = 0.0f;
		retNumber = Float.parseFloat(number.trim());
		return retNumber;
	}

	/**
	 * This method converts a string in an integer.
	 * 
	 * @param number
	 *            string value.
	 * 
	 * @return integer value.
	 */
	static int getInteger(String number) {

		int retNumber = 0;
		retNumber = Integer.parseInt(number.trim());
		return retNumber;
	}
	/**
     * This method prints some help information to start the program.
     */
    static void printUsage() {

        System.out
                .println("Error: The number of input arguments used for the writer-function is smaller than expected. Check the input arguments.");
    }
}
