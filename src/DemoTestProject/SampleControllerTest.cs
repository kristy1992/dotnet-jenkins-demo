namespace DemoTestProject
{
    using DemoWebApplication.Controller;
    using Xunit;
    public class SampleControllerTest
    {
        #region Private Members

        private readonly SampleController sampleController;

        #endregion

        #region Constructor
        /// <summary>
        /// Constructor
        /// </summary>

        public SampleControllerTest()
        {
            sampleController = new SampleController();
        }

        #endregion Constructor

        #region Tests

        /// <summary>
        /// Should return DDIM i.e. metadata of all features.
        /// </summary>
        [Fact]
        public void GetDefaultDesignIntentModel_WhenNoAgrumentsPassed_ReturnsDefaultDesignIntentModel()
        {
            #region Arrange
            string expectedOutput = System.IO.File.ReadAllText("ddim.json");
            #endregion

            #region Act
            string actualOutput = sampleController.GetDefaultDesignIntentModel().Value;
            #endregion

            #region Assert
            Assert.Equal(expectedOutput, actualOutput);
            #endregion
        }


        #endregion
    }
}