using LaPalace.Model;
using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows;
using System.Windows.Input;

namespace LaPalace.ViewModel.Commands
{
    public class RunCommand : ICommand
    {
        private LaPalaceVM VM { get; set; }

        public RunCommand(LaPalaceVM vm)
        {
            VM = vm;
        }

        public event EventHandler CanExecuteChanged
        {
            add
            {
                CommandManager.RequerySuggested += value;
            }
            remove
            {
                CommandManager.RequerySuggested -= value;
            }
        }

        public bool CanExecute(object parameter)
        { //TODO: recreate this section so it works on loaded image, not the filepath
            Bitmap inputImage = (Bitmap)parameter;
            return inputImage == null ? false : true;
        }

        public void Execute(object parameter)
        {
            RunFunction();
        }

        public void RunFunction()
        {
            double pixelNo = VM.InputImage.Size.Height * VM.InputImage.Size.Width;
            Stopwatch sw = new Stopwatch();
            try
            {
                sw.Start();
                VM.OutputImage = LaPalaceFilter.Run(VM.InputImage, VM.SelectedAlgorythm, VM.SelectedLibrary, VM.NumberOfThreads);
                sw.Stop();
                VM.BottomText = $"Processed {String.Format("{0:n0}", pixelNo)} pixels in {sw.ElapsedMilliseconds} ms using {VM.NumberOfThreads} thread/s.";
            }
            catch (Exception)
            {
                sw.Stop();
                VM.BottomText = $"Processing {String.Format("{0:n0}", pixelNo)} pixels took {sw.ElapsedMilliseconds} ms before cancellation.";
            }
        }
    }
}
