package adInterfaceReader;

/**
 * This is the driver class in ADinterfaceReader. 
 * It is used to call the C-function in the .dll to read the analog digital interface.
 *
 * @author Thierry Nouidui
 * @version 1.0
 */

public class ADInterfaceReader {
	/**
	 * This is the main routine that starts the program.
	 * 
	 */
	public static void main(String[] args) {

		//check the length of the arguments
		if (args.length != 4) {
            printUsage();
            System.exit(1);
        }
		// define a new object of the class ReadChannel
		ADInterface converter = new ADInterface();

		try {
			int boardnumber    = getInteger(args[0]);
			int channelnumber  = getInteger(args[1]);
			int channelgain    = getInteger(args[2]);
			// the next value could be set to any value 
			//it is needed by the reader function provided by the manufacturer
			float channelvalue = 0;
			int channeloptions = getInteger(args[3]);
			/**These are the common parameters used to read board number 0 
			 * int boardnumber = 0; int channelnumber = 0; int channelgain = 2; float channelvalue =
			 * 0; int channeloptions = 0;
			 */

			float UDRead = 0;
			// call the C-function to read the data from the channel
			UDRead = converter.cbVIn(boardnumber, channelnumber, channelgain, channelvalue,
					channeloptions);
			// print the result
			System.out.print(UDRead);
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
                .println("Error: The number of input arguments used for the reader-function is smaller than expected. Check the input arguments.");
    }
}
