import java.awt.*;
import java.applet.*;
import java.util.*;
import java.lang.*;

public class Vortex extends Frame {

	private Frame errorFrame;
	private Panel graphPanel,ioPanel;
    private Panel dataPanel,controlPanel;
	Choice unitsChoice,outputFormat;
	private TextField angleInput;
    String outputString;
    private Choice choice1,choice2;
	private Button clearButton,computeButton,helpButton;
	private TextArea inputText,outputText;

	private FoilShape foilShape;
	private CurveShape curveShape;
	public HelpVortex helpVortex;
	AirFoil airFoil;

	double[] xList;
    double[] yList;
	double[] cp,x,u,gamma,cl,cm;
    int nPts;
	double angle;
	int nAngleSteps;
	boolean cpdone,cldone,isRange;
	double[] alpha;

    public Vortex() {
		//try {
        setTitle("Vortex Panel Method");
		setLayout(new GridLayout(2,1,10,0));
        setBackground(Color.cyan);
		addNotify();

		graphPanel = new Panel();
		add(graphPanel);
		ioPanel = new Panel();
		add(ioPanel);

		graphPanel.setLayout(new GridLayout(1,2,10,10));
		graphPanel.setBackground(Color.white);
		foilShape = new FoilShape(this);
		graphPanel.add(foilShape);
		curveShape = new CurveShape(this);
		graphPanel.add(curveShape);

		ioPanel.setLayout(new BorderLayout(0,0));

		dataPanel = new Panel();
		dataPanel.setLayout(new GridLayout(2,1,10,0));

        inputText = new TextArea("Type/paste in the panel points. Select the units of angle of attack and type in the angle in the textfield");
        inputText.setFont(new Font("Dialog",Font.PLAIN,10));
		inputText.setBackground(Color.cyan);
        dataPanel.add(inputText);

        outputText=new TextArea("Press compute and results will appear here. Copy/paste these into your application.");
        outputText.setFont(new Font("Dialog",Font.PLAIN,10));
        outputText.setEditable(false);
        dataPanel.add(outputText);

        controlPanel = new Panel();
		controlPanel.setLayout(new GridLayout(1,5,10,0));
		controlPanel.setBackground(Color.cyan);

		unitsChoice= new Choice();
        unitsChoice.setFont(new Font("Dialog",Font.PLAIN,10));
		unitsChoice.setBackground(Color.cyan);
        controlPanel.add(unitsChoice);
        unitsChoice.addItem("AoA ( deg.)");
		unitsChoice.addItem("AoA ( rad.)");
		unitsChoice.addItem("AoA Range(deg.)");
		unitsChoice.addItem("AoA Range(rad.)");

		double pi = 4.0 * Math.atan(1.0);
		angle = 8.0 * pi/180 ;

		angleInput = new TextField("8.0",11);
        angleInput.setFont(new Font("Dialog",Font.PLAIN,10));
		angleInput.setBackground(Color.white);
		controlPanel.add(angleInput);

		outputFormat = new Choice();
		outputFormat.setFont(new Font("Dialog",Font.PLAIN,10));
		outputFormat.setBackground(Color.cyan);
		outputFormat.addItem("All Data");
		outputFormat.addItem("Panel Strengths");
        outputFormat.addItem("s , U (upper)");
		outputFormat.addItem("s , U (lower)");
		outputFormat.addItem("s , 0 , U (upper)");
		outputFormat.addItem("s , 0 , U (lower)");
		controlPanel.add(outputFormat);


        computeButton = new Button("Compute");
        clearButton = new Button("Clear");
        helpButton = new Button("Help");

		controlPanel.add(clearButton);
        controlPanel.add(computeButton);
        controlPanel.add(helpButton);

        ioPanel.add("Center",dataPanel);
        ioPanel.add("South",controlPanel);

		xList = new double[1000];
		yList = new double[1000];

		nAngleSteps = 10;
		cl = new double[nAngleSteps+2];
		cm = new double[nAngleSteps+2];
		alpha = new double[nAngleSteps+2];

		nPts = 0;
		cldone=false;
		cpdone=false;

    }

	public void paint(Graphics g) {

		foilShape.repaint();
		curveShape.repaint();

	}
    public boolean handleEvent(Event event) {

		if ((event.id == Event.ACTION_EVENT) && (event.target == unitsChoice)) {
			cldone=false;cpdone=false;
			cl[0]=cm[0]=0.0;
		    if(unitsChoice.getSelectedIndex()==0 || unitsChoice.getSelectedIndex()==1 & !outputFormat.isEnabled()) {
			    outputFormat.enable();
			    outputFormat.select(0);
			}
		    if(unitsChoice.getSelectedIndex()==2 || unitsChoice.getSelectedIndex()==3 & outputFormat.isEnabled()) {
			    outputFormat.disable();
			}
			repaint();
			return true;
		}
        else if ((event.id == Event.ACTION_EVENT) && (event.target == clearButton)) {
			outputText.setText("");
            inputText.setText("");
			cpdone=false;cldone=false;
			cl[0]=cm[0]=0.0;
			nPts = 0;
			xList = yList = null;
			xList = new double[1000];
			yList = new double[1000];
			repaint();
            return true;
        }
        else if ((event.id == Event.ACTION_EVENT) && (event.target == helpButton)) {
			if(helpVortex == null)
			{
				helpVortex = new HelpVortex(this);
				helpVortex.resize(330,500);
				helpVortex.show(true);
			}
			return true;
		}
		else if ((event.id == Event.ACTION_EVENT) && (event.target == outputFormat)) {
			tabulate();
			return true;
		}
		else if ((event.id == Event.ACTION_EVENT) && (event.target == computeButton)) {

			if(inputText.getText().equals("Type/paste in the panel points. Select the units of angle of attack and type in the angle in the textfield")
					||inputText.getText().equals("")) {
				inputText.setText("1\t0\n0.95\t-0.00807\n0.9\t-0.01448\n0.8\t-0.02623\n0.7\t-0.03664\n0.6\t-0.04563\n0.5\t-0.05294\n0.4\t-0.05803\n0.3\t-0.06002\n0.25\t-0.05941\n0.2\t-0.05737\n0.15\t-0.05345\n0.1\t-0.04683\n0.075\t-0.042\n0.05\t-0.03555\n0.025\t-0.02615\n0.0125\t-0.01894\n0\t0\n0.0125\t0.01894\n0.025\t0.02615\n0.05\t0.03555\n0.075\t0.042\n0.1\t0.04683\n0.15\t0.05345\n0.2\t0.05737\n0.25\t0.05941\n0.3\t0.06002\n0.4\t0.05803\n0.5\t0.05294\n0.6\t0.04563\n0.7\t0.03664\n0.8\t0.02623\n0.9\t0.01448\n0.95\t0.00807\n1\t0");
				outputText.setText("Example NACA 0012 data entered");
				cpdone=false;cldone=false;
				cl[0]=cm[0]=0.0;
				repaint();
				return true;
			}

			if(getInput(inputText.getText()) & getAngle(angleInput.getText())) {
				if(xList[nPts]!=xList[1] || yList[nPts]!=yList[1]) {
					outputText.setText(" First and Last Points should be the same ..\n");
					cpdone=false;cldone=false;
					cl[0]=cm[0]=0.0;
				    outputText.setText("");
					repaint();
					return true;
				}

				computeButton.disable();
				computeButton.setLabel("Thinking...");

    			airFoil = new AirFoil(xList,yList,nPts);

        		if(unitsChoice.getSelectedIndex()==0 || unitsChoice.getSelectedIndex()==1) {
    			    airFoil.computeValues(angle);
					cl[0]=cm[0]=0.0;
		            for(int i=1;i<=nPts-1;i++) {	//determine Cl and Cm
			            cl[0]+=2.*Math.PI*airFoil.s[i]*(airFoil.gamma[i]+airFoil.gamma[i+1]);
			            cm[0]+=4.*Math.PI*(airFoil.s[i]*(airFoil.gamma[i]+airFoil.gamma[i+1])*(0.25-airFoil.xb[i])/2.0
							-Math.cos(airFoil.theta[i]-angle)*airFoil.s[i]*airFoil.s[i]*(airFoil.gamma[i+1]/3.0+airFoil.gamma[i]/6.0));
			      	}
  					tabulate();
                }
                else {
					outputString = "alpha            \tCl             \tCm\n";
					if(angle<0.0) angle=-angle;
					if(angle<0.01) angle=0.01;
					for(int j= 1;j<=nAngleSteps+1;j++) {
					    alpha[j]=-angle + (j-1)*2*angle/nAngleSteps;
						airFoil.computeValues(alpha[j]);
						cl[j]=0.0;cm[j]=0.0;
		                for(int i=1;i<=nPts-1;i++) {
			                cl[j]+=2.*Math.PI*airFoil.s[i]*(airFoil.gamma[i]+airFoil.gamma[i+1]);
			                cm[j]+=4.*Math.PI*(airFoil.s[i]*(airFoil.gamma[i]+airFoil.gamma[i+1])*(0.25-airFoil.xb[i])/2.0
								-Math.cos(airFoil.theta[i]-alpha[j])*airFoil.s[i]*airFoil.s[i]*(airFoil.gamma[i+1]/3.0+airFoil.gamma[i]/6.0));
			      		}
						if(unitsChoice.getSelectedIndex()==3)
						            outputString+=fformat(alpha[j])+"\t"+ fformat(cl[j])+"\t"+fformat(cm[j])+"\n";
						else if(unitsChoice.getSelectedIndex()==2)
						            outputString+=fformat(alpha[j]*180/Math.PI)+"\t"+ fformat(cl[j])+"\t"+fformat(cm[j])+"\n";
					}
					outputText.setText(outputString);
                }
				cldone=true;cpdone=true;

				computeButton.enable();
				computeButton.setLabel("Compute");

    			repaint();
			    return true;
            }
        }
        else if (event.id == Event.WINDOW_DESTROY) {
            hide();
            return true;
        }

		return super.handleEvent(event);
    }


	private boolean getAngle(String angleString) {
		try {
			double angleRD = (new Double(angleString)).doubleValue();
			if(unitsChoice.getSelectedIndex()==0||unitsChoice.getSelectedIndex()==2) angle = angleRD * Math.PI/180.0;
			else angle = angleRD;
		} catch(NumberFormatException nFE) {
			outputText.setText(" Wrong Input For Angle..");
			return false;
		}
		return true;
	}

	private boolean getInput(String nolist) {

		char[] delim={' ',',','\n','\t','\r','\f'};
		String table,datas;
		Double DdataD = new Double(0.0);
        int i,j;

        table=new String(nolist);

        //Replace all delimiters by spaces
        for(i=1;i<6;i++) {
            table=table.replace(delim[i],' ');
        }

        for(j=2,nPts=0;;) {
            //trim leading and trailing whitespaces
            table=table.trim();
            if(table.length()==0) break;
            if(table.indexOf(' ') == -1) {
                datas=table;table="";
            }
            else {
                datas=table.substring(0,table.indexOf(' '));
                table=table.substring(table.indexOf(' '));
            }

            try {
                DdataD=Double.valueOf(datas);
            }
            catch (NumberFormatException nFE) {
                perror("Number format error. Use only spaces, commas or carriage returns as delimeters");
                return false;
            }

            if(j%2==0) {
                xList[j/2]=DdataD.doubleValue();
                j++;
            }
            else {
                yList[(j-1)/2]=DdataD.doubleValue();
                j++;
                nPts++;
                if(nPts==1000) break;
            }


        }
        if(nPts<2) perror("Less than two numbers entered. Enter at least 2");
		return true;
	}

    private void perror(String msg) {
        try {
            inputText.setText(msg);
        } catch (NullPointerException nPE) {}
        nPts=0;
    }

    private String fformat(double d) {  //fixed scientific format
        String out="",buf;
        String[] zeros={"0.","0.0","0.00"};
        int mant,exp,sgn=1,esgn=1;
        int sdigits=5;         //number of digits to show in scientific format

        if(d>0.0) sgn=1;
        else if(d<0.0) sgn=-1;
        else return(" 0.0000e+000");

        buf=String.valueOf(d);
        if(buf.indexOf('#')>=0) {
            buf=buf+"?             ";
            return(buf.substring(0,11)); //catches infinities
        }

        d=Math.abs(d);
        exp=(int)(Math.log(d*1.0000001)/Math.log(10));
        if(d<1.0) exp--;

        mant=(int)Math.round(d*Math.pow(10.,(double)(sdigits-1-exp)));
        buf=String.valueOf(mant);
        out=buf.substring(0,1)+"."+buf.substring(1); //insert point
        if(sgn==-1) out="-"+out;
        else out=" "+out;
        if(exp>=0) out=out+"e+";
        else out=out+"e-";
        if(Math.abs(exp)>99) out=out+String.valueOf(Math.abs(exp));
        else if(Math.abs(exp)>9) out=out+"0"+String.valueOf(Math.abs(exp));
        else out=out+"00"+String.valueOf(Math.abs(exp));

        return(out);

    }

    public void tabulate() {
    	double s;
		int si,index,choice,m,i;

		m=nPts-1;
		index =outputFormat.getSelectedIndex();
    	outputText.setText("");

		if (index==0) {
			outputString="x/c             \ty/c            \tu/Uinf             \tv/Uinf               \tV/Uinf             \tCp\n";
			for(i=1;i<=m;i++) outputString+=fformat(airFoil.x[i])+"\t"+
        				                    fformat(airFoil.y[i])+"\t"+
        				                    fformat(airFoil.v[i]*Math.cos(airFoil.theta[i]))+"\t"+
        				                    fformat(airFoil.v[i]*Math.sin(airFoil.theta[i]))+"\t"+
        				                    fformat(airFoil.v[i])+"\t"+
        				                    fformat(airFoil.cp[i])+"\n";
		}
		if(index==1) {
			outputString = "x/c            \ty/c            \tPanel strength/Uinf\n";
			for(i=1;i<=nPts;i++) {
				outputString+=fformat(xList[i])+"\t"+fformat(yList[i])+"\t"+fformat(airFoil.gamma[i])+"\n";
			}
		}
		if(index==2 || index==4) {
		    if (index==2) outputString = "s/c            \tV/Uinf(upper)\n"+fformat(0.0)+"\t"+fformat(0.0)+"\n";
		    else outputString = "s/c             \t(zero)          \tV/Uinf(upper)\n"+ fformat(0.0)+"\t"+fformat(0.0)+"\t"+fformat(0.0)+"\n";
		    airFoil.getStagPt();
			for(i=airFoil.si,s=0.0;i<=m;i++) {
		        if(i==airFoil.si) s=Math.sqrt(Math.pow(airFoil.x[i]-airFoil.sx,2)+Math.pow(airFoil.y[i]-airFoil.sy,2));
		        else s+=Math.sqrt(Math.pow(airFoil.x[i]-airFoil.x[i-1],2)+Math.pow(airFoil.y[i]-airFoil.y[i-1],2));
		        if (index==2) outputString+=fformat(s)+"\t"+fformat(airFoil.v[i])+"\n";
		        else outputString+=fformat(s)+"\t"+fformat(0.0)+"\t"+fformat(airFoil.v[i])+"\n";
		    }
		}
		if(index==3 || index==5) {
		    if (index==3) outputString = "s/c            \tV/Uinf(lower)\n"+fformat(0.0)+"\t"+fformat(0.0)+"\n";
		    else outputString = "s/c            \t(zero)            \tV/Uinf(lower)\n"+ fformat(0.0)+"\t"+fformat(0.0)+"\t"+fformat(0.0)+"\n";
		    airFoil.getStagPt();
			for(i=airFoil.si-1,s=0.0;i>=1;i--) {
		        if(i==airFoil.si-1) s=Math.sqrt(Math.pow(airFoil.x[i]-airFoil.sx,2)+Math.pow(airFoil.y[i]-airFoil.sy,2));
		        else s+=Math.sqrt(Math.pow(airFoil.x[i]-airFoil.x[i+1],2)+Math.pow(airFoil.y[i]-airFoil.y[i+1],2));
		        if (index==3) outputString+=fformat(s)+"\t"+fformat(-airFoil.v[i])+"\n";
		        else outputString+=fformat(s)+"\t"+fformat(0.0)+"\t"+fformat(-airFoil.v[i])+"\n";
		    }
		}
	    outputText.setText(outputString);
	}


}



