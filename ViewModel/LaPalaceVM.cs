using LaPalace.Model;
using LaPalace.ViewModel.Commands;
using LaPalace.ViewModel.FileOperations;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Windows;
using System.Windows.Media.Imaging;

namespace LaPalace.ViewModel
{
    public class LaPalaceVM : INotifyPropertyChanged
    {
        public LaPalaceVM()
        {
            ImportCommand = new ImportCommand(this);
            RunCommand = new RunCommand(this);
            SaveCommand = new SaveCommand(this);
            ReportCommand = new ReportCommand(this);
        }

        private string bottomText = "LaPalace app is ready for your orders!";
        public string BottomText
        {
            get { return bottomText; }
            set
            {
                bottomText = value;
                OnPropertyChanged("BottomText");
            }
        }

        private bool isResultReady = false;
        public bool IsResultReady
        {
            get => isResultReady;
            set
            {
                isResultReady = value;
                OnPropertyChanged("IsResultReady");
            }
        }

        private int numberOfThreads = 1;
        public int NumberOfThreads
        {
            get => numberOfThreads;
            set
            {
                numberOfThreads = value < 1 ? 1 : (value > 64 ? 64 : value);
                OnPropertyChanged("NumberOfThreads");
            }
        }

        private string imagePath;
        public string ImagePath
        {
            get { return imagePath; }
            set
            {
                imagePath = value;
                OnPropertyChanged("ImagePath");
            }
        }

        public IEnumerable<AlgorythmChoices> AlgorythmChoicesTypeValues
            => Enum.GetValues(typeof(AlgorythmChoices)).Cast<AlgorythmChoices>();
        private AlgorythmChoices selectedAlgorythm;
        public AlgorythmChoices SelectedAlgorythm
        {
            get { return selectedAlgorythm; }
            set
            {
                selectedAlgorythm = value;
                OnPropertyChanged("SelectedAlgorythm");
            }
        }

        public IEnumerable<LibraryChoices> LibraryChoicesTypeValues
            => Enum.GetValues(typeof(LibraryChoices)).Cast<LibraryChoices>();
        private LibraryChoices selectedLibrary;
        public LibraryChoices SelectedLibrary
        {
            get => selectedLibrary;
            set
            {
                selectedLibrary = value;
                OnPropertyChanged("SelectedLibrary");
            }
        }

        public ImportCommand ImportCommand { get; set; }
        public RunCommand RunCommand { get; set; }
        public SaveCommand SaveCommand { get; set; }
        public ReportCommand ReportCommand { get; set; }

        public void RunFunction()
        {
            IsResultReady = LaPalaceFilter.ApplyFilter(ImportedPicture);
        }
        public void SaveFunction() { }

        public void ReportFunction() { }

        public void ImportFile()
        {
            string newImagePath = FileOpener.OpenFile();
            if (ImagePath != newImagePath)
            {
                ImagePath = newImagePath;
                try
                {
                    ImportedPicture = new Bitmap(ImagePath);
                    IsResultReady = false;
                }
                catch { }
            }
        }

        private BitmapImage bitmapImageSource;
        public BitmapImage BitmapImageSource
        {
            get { return bitmapImageSource; }
            set
            {
                bitmapImageSource = value;
                OnPropertyChanged("BitmapImageSource");
            }
        }
        private Bitmap importedPicture;
        public Bitmap ImportedPicture
        {
            get { return importedPicture; }
            set
            {
                importedPicture = value;
                BitmapImageSource = importedPicture == null ? null : FileOpener.BitmapToImageSource(importedPicture);
                OnPropertyChanged("ImportedPicture");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void OnPropertyChanged(string propertyName)
            => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}
