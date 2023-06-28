using System.ComponentModel.DataAnnotations;

using Fmi.Configuration.Validation;

namespace ReferenceData.Configuration
{
    public class ConnectionStrings : ConfigurationValidator
    {
        [Required]
        public string ReferenceData { get; set; }
    }
}
