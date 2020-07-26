using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace DemoWebApplication.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        #region Private Fields

        private const string DDIM_FilePath = "ddim.json";

        #endregion    

        #region Actions

        /// <summary>
        /// Returns DDIM i.e. metadata of all features.
        /// </summary>
        /// <returns></returns>
        [HttpGet("default")]
        public ActionResult<string> GetDefaultDesignIntentModel()
        {
            return System.IO.File.ReadAllText(DDIM_FilePath);
        }

        #endregion
    }
}