using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ExcelIndexFinder
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void TextBoxInput_TextChanged(object sender, EventArgs e)
        {
            var text = ((TextBox)sender).Text;
            bool isNumeric = int.TryParse(text, out int number);
            if (isNumeric)
            {
                //Give text as result - inefficient but whatever
                if (number >= 99999 || number <= 0)
                {
                    LabelResult.Text = "Input invalid";
                    return;
                }

                string currentText = "a";
                int count = 0;
                while (TextToIndex(currentText) != number)
                {
                    foreach (var x in GetPermutationsWithRept("abcdefghijklmnopqrstuvwxyz", count))
                    {
                        currentText = new string(x.ToArray());
                        if (TextToIndex(currentText) == number)
                        {
                            break;
                        }
                    }
                    count++;
                }
                LabelResult.Text = currentText;
            }
            else
            {
                if (!text.Any(c => char.IsLetter(c)))
                {
                    LabelResult.Text = "Input invalid";
                    return;
                }
                int result = TextToIndex(text);
                //Give number as result
                LabelResult.Text = result.ToString();
            }
        }

        public int TextToIndex(string text)
        {
            text = text.ToUpper();
            int length = text.Length;
            int result = 0;
            int exponent = length - 1;
            for (int i = 0; i < length; i++)
            {
                int multiplier = text[i] - 'A' + 1;
                result = result + (int)Math.Pow(26, exponent) * multiplier;
                exponent--;
            }
            return result;
        }

        static IEnumerable<IEnumerable<T>> GetPermutations<T>(IEnumerable<T> list, int length)
        {
            if (length == 0) return new List<List<T>>();
            if (length == 1) return list.Select(t => new T[] { t });

            return GetPermutations(list, length - 1)
                .SelectMany(t => list.Where(e => !t.Contains(e)),
                    (t1, t2) => t1.Concat(new T[] { t2 }));
        }

        static IEnumerable<IEnumerable<T>> GetPermutationsWithRept<T>(IEnumerable<T> list, int length)
        {
            if (length == 0) return new List<List<T>>();
            if (length == 1) return list.Select(t => new T[] { t });
            return GetPermutationsWithRept(list, length - 1)
                .SelectMany(t => list,
                    (t1, t2) => t1.Concat(new T[] { t2 }));
        }
    }
}
