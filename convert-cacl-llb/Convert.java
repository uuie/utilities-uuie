import java.awt.List;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;


public class Convert {
    public static Map<String,String> opsArr=new HashMap<String,String>();
	public static  String inFile;//="/Users/chris/Desktop/t=500.00000.dat";
	public static  String outFile;//=inFile+".out";
	public static double val1;//=Math.sin((Math.PI*0.7)/2)* Math.sqrt(2/Math.sin(Math.PI*0.55));
	public static double val2;//=Math.cos((Math.PI*0.7)/2)* Math.sqrt(2/Math.sin(Math.PI*0.55));
	public static BigDecimal mutiplier0=new BigDecimal(val1);
	public static BigDecimal mutiplier1=new BigDecimal(val2);
	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		
		inFile=args[0];
		outFile=args[1];
		
		if(args.length>=3)
		{
			for(int i=2;i<args.length;++i)
			{
				String ops=args[i];
				String oparr[]=ops.split("=");
				opsArr.put(oparr[0].trim(),oparr[1].trim());	
			}
		}
		
		// TODO Auto-generated method stub
		DecimalFormat df=new DecimalFormat(".000000E00;-.000000E00");

		BufferedReader br=new BufferedReader(new FileReader(new File(inFile)));
		BufferedWriter bw=new BufferedWriter(new FileWriter(new File(outFile)));
		String aLine=null;
		while((aLine=br.readLine())!=null)
		{
			if(!aLine.startsWith("  "))
			{
				Convert.output(bw,aLine);
				Convert.output(bw, "\n");
				continue;
			}
			String[] objs=aLine.split("\\s+");
			int idx=0;
			for(String obj:objs)
			{	
	            if(obj.trim().equals(""))
	            	continue;
				BigDecimal val=new BigDecimal(obj.trim());
				String strVal=obj.startsWith("-")?"  "+obj:"   "+obj;
				String key="col"+(idx+1);
				if(opsArr.containsKey(key))
				{
					val=performOps(val,opsArr.get(key));
					strVal=replaceFormat(df.format(val));
				}
				
				++idx;
				
				Convert.output(bw,strVal);
			}
			Convert.output(bw, "\n");
		}
		br.close();
		bw.close();
		System.out.println(String.format("file %s generated",outFile));
	};
	public static String replaceFormat(String str)
	{
		return str.replaceAll("^\\.", "   0.")
				.replaceAll("^\\-\\.", "  -0.")
				.replaceAll("E(\\d\\d)$","E+$1");
	}
	public static void output(BufferedWriter bw,String val) throws IOException
	{
		bw.write(val);
	}
	
	public static BigDecimal performOps(BigDecimal val,String ops)
	{
	
		java.util.List<String> opsArr=new ArrayList<String>(); 
		opsArr.addAll(Arrays.asList(ops.split("[\\d\\.]+")));
		java.util.List<String> valArr=new ArrayList<String>();
		valArr.addAll(Arrays.asList(ops.split("[\\+\\-\\*/]")));
		for(String s :opsArr)
		{
			if(s.trim().equals("+"))
			{
				val=val.add(new BigDecimal(fetchStringValFromList(valArr)));
			}else if(s.trim().equals("-"))
			{
				val=val.subtract(new BigDecimal(fetchStringValFromList(valArr)));
			}else if(s.trim().equals("*"))
			{
				val=val.multiply(new BigDecimal(fetchStringValFromList(valArr)));
			}else if(s.trim().equals("/"))
			{
				val=val.divide(new BigDecimal(fetchStringValFromList(valArr)));
			}
		}
//		Stringp[] valArr=ops.split("[+-*/]");
		return val;
	}
	private static String fetchStringValFromList(java.util.List<String> list)
	{
		String s=null;
		do
		{
			s=list.remove(0);
		}while(s.trim().equals(""));
		return s;
	}
}
