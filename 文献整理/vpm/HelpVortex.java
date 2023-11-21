import java.applet.*;
import java.awt.*;
import java.util.*;

public class HelpVortex extends Frame
{
	private Panel helpPanel,buttonPanel;
	private Label presLabel,gsLabel;
	private Vortex vortex;
	private Button okButton;
	private TextArea helpText;
	private String[] helpStrings;

	public HelpVortex(Vortex vor) {
		vortex = vor;	

//*********************************************************
		setTitle("Help");
		setBackground(Color.yellow);
		setLayout(new BorderLayout());

		helpPanel = new Panel();
		helpPanel.setLayout(new GridLayout(1,1));
		helpText = new TextArea();
		helpText.setFont(new Font("Dialog",Font.PLAIN,12));
        helpText.setEditable(false);
        helpPanel.add(helpText);
		add("Center",helpPanel);
		
		buttonPanel = new Panel();
		buttonPanel.setLayout(new FlowLayout());

		okButton = new Button("OK");
		buttonPanel.add(okButton);

		add("South",buttonPanel);

		helpStrings = new String[15];

		helpStrings[0] = "This applet implements a Vortex Panel Method\ncalculation of the potential flow past a specified airfoil\n\n";
		helpStrings[1] = "1. To specify the airfoil type first press the 'Clear' button to \n\tclear the input table (the upper text area).\n\n";
		helpStrings[2] = "2. Type into the input table pairs of numbers specifying\n\tthe x,y coordinates of the airfoil at the panel\n\tboundaries. ";
		helpStrings[3] = "Start with the trailing edge 0,1,\n\tproceed around the lower surface to the\n\tleading edge 0,0 and then along the upper \n\tsurface. End by repeating the trailing edge point.\n\n";
		helpStrings[4] = "3. Enter as many pairs of values as you like using commas,\n\tspaces, tabs or linefeeds as delimeters\n\n";
		helpStrings[5] = "4. Select 'AoA(deg)' or 'AoA'(rad)' at the lower left and\n\ttype in the angle of attack in the adjacent cell.\n\n";
		helpStrings[6] = "5. Press the 'Compute' button\n\n";
		helpStrings[7] = "6. Numerical results are displayed in the output (lower)\n\ttable. Different results may be viewed by\n\tby changing the 'All Data' selector\n\n";
		helpStrings[8] = "7. Graphical results (the panelled airfoil) and the Cp\n\tdistribution are plotted at the top of the applet.\n\n";
		helpStrings[9] = "8. Alternatively select 'AoA range (deg)' or 'AoA range (rad)'\n\t to compute the variations in lift and moment\n\tcoefficient over a range of angles of attack.\n\n";
		helpStrings[10] = "9. Press 'Clear' and then 'Compute' to load example\n\tcoordinates for a NACA0012 airfoil.\n\n";
		helpStrings[11] = "10. Airfoil coordinates may be pasted in from Excel\n\tor similar applications. Results may be copied back into\n\tExcel for plotting or into other applets for\n\tfurther calculation.";

		helpText.setText(helpStrings[0]+helpStrings[1]+helpStrings[2]+helpStrings[3]+helpStrings[4]+helpStrings[5]+helpStrings[6]+helpStrings[7]+helpStrings[8]+helpStrings[9]+helpStrings[10]+helpStrings[11]);
	

	}
	
	public boolean handleEvent(Event event) {
		
		if((event.id == Event.ACTION_EVENT)&&(event.target == okButton)) {
			hide();
			vortex.helpVortex = null;
			return true;
		}
		else if (event.id == Event.WINDOW_DESTROY) {
			hide();
			vortex.helpVortex = null;
            return true;
		}
		return super.handleEvent(event);
	}

}