import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { submitSustainabilityReport } from '../../services/carbon_contract_service';

const REPORT_CATEGORIES = [
  'Renewable Energy',
  'Waste Reduction',
  'Carbon Offset',
  'Sustainable Agriculture',
  'Forest Conservation',
  'Ocean Conservation',
  'Clean Water Initiative',
  'Biodiversity Protection',
  'Circular Economy',
  'Sustainable Transportation'
];

const ReportSubmissionModal = ({ isOpen, onClose }) => {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    category: REPORT_CATEGORIES[0],
    evidenceLink: '',
    latitudeValue: '',
    latitudeDirection: 'N',
    longitudeValue: '',
    longitudeDirection: 'E'
  });
  
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitResult, setSubmitResult] = useState(null);
  const [errors, setErrors] = useState({});
  const [networkError, setNetworkError] = useState(null);
  
  // Handle text input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    
    // Clear error for this field if it exists
    if (errors[name]) {
      setErrors(prev => ({
        ...prev,
        [name]: null
      }));
    }
  };
  
  // Handle direction select changes
  const handleDirectionChange = (name, value) => {
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };
  
  // Validate form data
  const validateForm = () => {
    const newErrors = {};
    
    if (!formData.title.trim()) newErrors.title = 'Title is required';
    if (!formData.description.trim()) newErrors.description = 'Description is required';
    if (!formData.category) newErrors.category = 'Category is required';
    if (!formData.latitudeValue) newErrors.latitudeValue = 'Latitude is required';
    if (!formData.longitudeValue) newErrors.longitudeValue = 'Longitude is required';
    
    // Validate URL format, but only if one is provided
    if (formData.evidenceLink && formData.evidenceLink.trim() && !formData.evidenceLink.match(/^https?:\/\/.+/)) {
      newErrors.evidenceLink = 'Please enter a valid URL starting with http:// or https://';
    }
    
    // Validate coordinate values
    if (formData.latitudeValue && (isNaN(formData.latitudeValue) || formData.latitudeValue < 0 || formData.latitudeValue > 9000)) {
      newErrors.latitudeValue = 'Latitude must be a number between 0 and 90.00';
    }
    
    if (formData.longitudeValue && (isNaN(formData.longitudeValue) || formData.longitudeValue < 0 || formData.longitudeValue > 18000)) {
      newErrors.longitudeValue = 'Longitude must be a number between 0 and 180.00';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };
  
  // Submit form
  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Clear previous results
    setSubmitResult(null);
    setNetworkError(null);
    
    // Validate form
    if (!validateForm()) return;
    
    try {
      setIsSubmitting(true);
      
      // Format coordinates
      const formattedLatValue = Math.round(parseFloat(formData.latitudeValue) * 100);
      const formattedLongValue = Math.round(parseFloat(formData.longitudeValue) * 100);
      
      // Prepare report data
      const reportData = {
        title: formData.title,
        description: formData.description,
        category: formData.category,
        evidenceLink: formData.evidenceLink,
        latitudeValue: formattedLatValue,
        latitudeDirection: formData.latitudeDirection,
        longitudeValue: formattedLongValue,
        longitudeDirection: formData.longitudeDirection
      };
      
      // Submit report to blockchain
      const result = await submitSustainabilityReport(reportData);
      
      if (result.success) {
        setSubmitResult({
          success: true,
          message: 'Report submitted successfully',
          txHash: result.txHash
        });
        
        // Reset form after successful submission
        setFormData({
          title: '',
          description: '',
          category: REPORT_CATEGORIES[0],
          evidenceLink: '',
          latitudeValue: '',
          latitudeDirection: 'N',
          longitudeValue: '',
          longitudeDirection: 'E'
        });
        
        // Close modal after 3 seconds
        setTimeout(() => {
          onClose();
          setSubmitResult(null);
        }, 3000);
      } else {
        setSubmitResult({
          success: false,
          message: result.error || 'Failed to submit report'
        });
        
        if (result.error && result.error.includes('network')) {
          setNetworkError('Please make sure you are connected to the Sepolia testnet in MetaMask.');
        }
      }
    } catch (error) {
      console.error('Error submitting report:', error);
      
      setSubmitResult({
        success: false,
        message: error.message || 'An unexpected error occurred'
      });
      
      // Check for specific error messages related to network issues
      if (
        error.message && (
          error.message.includes('network') || 
          error.message.includes('chain') ||
          error.message.includes('Sepolia') ||
          error.message.includes('rejected')
        )
      ) {
        setNetworkError('Please make sure you are connected to the Sepolia testnet in MetaMask and that you approved the transaction.');
      }
    } finally {
      setIsSubmitting(false);
    }
  };
  
  // Close modal
  const handleClose = () => {
    if (!isSubmitting) {
      onClose();
      
      // Reset state
      setSubmitResult(null);
      setErrors({});
      setNetworkError(null);
    }
  };
  
  if (!isOpen) return null;
  
  return (
    <AnimatePresence>
      <div className="fixed inset-0 flex items-center justify-center z-50 bg-black/50 backdrop-blur-sm">
        <motion.div 
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.95 }}
          className="bg-[#1E293B]/90 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/20 w-full max-w-2xl max-h-[90vh] overflow-y-auto"
        >
          {/* Header */}
          <div className="flex justify-between items-center p-6 border-b border-[#76EAD7]/10">
            <h2 className="text-xl font-semibold text-white">Submit Sustainability Report</h2>
            <button 
              onClick={handleClose}
              disabled={isSubmitting}
              className="text-[#94A3B8] hover:text-white transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          
          {/* Show network error if present */}
          {networkError && (
            <div className="mx-6 mt-4 p-4 bg-red-900/30 border border-red-500/40 rounded-lg">
              <div className="flex">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-red-400 mr-2 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
                <p className="text-red-200 text-sm">{networkError}</p>
              </div>
            </div>
          )}
          
          {/* Body */}
          <div className="p-6">
            {submitResult ? (
              <div className={`p-6 rounded-xl text-center ${
                submitResult.success 
                  ? 'bg-green-900/20 border border-green-500/30' 
                  : 'bg-red-900/20 border border-red-500/30'
              }`}>
                <div className="w-16 h-16 mx-auto mb-4 rounded-full flex items-center justify-center bg-gradient-to-r from-[#76EAD7]/20 to-[#C4FB6D]/20">
                  {submitResult.success ? (
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 text-green-400" viewBox="0 0 20 20" fill="currentColor">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  ) : (
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                    </svg>
                  )}
                </div>
                <h3 className="text-lg font-medium text-white mb-2">
                  {submitResult.success ? 'Report Submitted!' : 'Submission Failed'}
                </h3>
                <p className="text-[#94A3B8] mb-4">{submitResult.message}</p>
                
                {submitResult.success && submitResult.txHash && (
                  <a 
                    href={`https://sepolia.etherscan.io/tx/${submitResult.txHash}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center text-[#76EAD7] hover:underline"
                  >
                    <span>View on Etherscan</span>
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 ml-1" viewBox="0 0 20 20" fill="currentColor">
                      <path d="M11 3a1 1 0 100 2h2.586l-6.293 6.293a1 1 0 101.414 1.414L15 6.414V9a1 1 0 102 0V4a1 1 0 00-1-1h-5z" />
                      <path d="M5 5a2 2 0 00-2 2v8a2 2 0 002 2h8a2 2 0 002-2v-3a1 1 0 10-2 0v3H5V7h3a1 1 0 000-2H5z" />
                    </svg>
                  </a>
                )}
              </div>
            ) : (
              <form onSubmit={handleSubmit}>
                {/* Form fields */}
                <div className="space-y-6">
                  {/* Title */}
                  <div>
                    <label className="block text-[#94A3B8] text-sm font-medium mb-2" htmlFor="title">
                      Report Title*
                    </label>
                    <input
                      type="text"
                      id="title"
                      name="title"
                      value={formData.title}
                      onChange={handleInputChange}
                      className={`w-full px-4 py-2 bg-[#0F172A] border ${
                        errors.title ? 'border-red-500' : 'border-[#76EAD7]/20'
                      } rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50`}
                      placeholder="E.g., Annual Carbon Reduction Initiative"
                      disabled={isSubmitting}
                    />
                    {errors.title && (
                      <p className="mt-1 text-sm text-red-400">{errors.title}</p>
                    )}
                  </div>
                  
                  {/* Category */}
                  <div>
                    <label className="block text-[#94A3B8] text-sm font-medium mb-2" htmlFor="category">
                      Category*
                    </label>
                    <select
                      id="category"
                      name="category"
                      value={formData.category}
                      onChange={handleInputChange}
                      className={`w-full px-4 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50`}
                      disabled={isSubmitting}
                    >
                      {REPORT_CATEGORIES.map(category => (
                        <option key={category} value={category}>{category}</option>
                      ))}
                    </select>
                  </div>
                  
                  {/* Description */}
                  <div>
                    <label className="block text-[#94A3B8] text-sm font-medium mb-2" htmlFor="description">
                      Description*
                    </label>
                    <textarea
                      id="description"
                      name="description"
                      value={formData.description}
                      onChange={handleInputChange}
                      rows={4}
                      className={`w-full px-4 py-2 bg-[#0F172A] border ${
                        errors.description ? 'border-red-500' : 'border-[#76EAD7]/20'
                      } rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50 resize-none`}
                      placeholder="Describe your sustainability initiative and its impact..."
                      disabled={isSubmitting}
                    />
                    {errors.description && (
                      <p className="mt-1 text-sm text-red-400">{errors.description}</p>
                    )}
                  </div>
                  
                  {/* Evidence Link */}
                  <div>
                    <label className="block text-[#94A3B8] text-sm font-medium mb-2" htmlFor="evidenceLink">
                      Evidence Link (Optional)
                    </label>
                    <input
                      type="text"
                      id="evidenceLink"
                      name="evidenceLink"
                      value={formData.evidenceLink}
                      onChange={handleInputChange}
                      className={`w-full px-4 py-2 bg-[#0F172A] border ${
                        errors.evidenceLink ? 'border-red-500' : 'border-[#76EAD7]/20'
                      } rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50`}
                      placeholder="https://example.com/evidence"
                      disabled={isSubmitting}
                    />
                    {errors.evidenceLink && (
                      <p className="mt-1 text-sm text-red-400">{errors.evidenceLink}</p>
                    )}
                    <p className="mt-1 text-xs text-[#94A3B8]">
                      Link to documents, images, or other evidence supporting your report
                    </p>
                  </div>
                  
                  {/* Location Coordinates */}
                  <div>
                    <h3 className="text-[#94A3B8] text-sm font-medium mb-3">Project Location*</h3>
                    
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      {/* Latitude */}
                      <div>
                        <label className="block text-[#94A3B8] text-sm mb-2" htmlFor="latitudeValue">
                          Latitude
                        </label>
                        <div className="flex">
                          <input
                            type="number"
                            id="latitudeValue"
                            name="latitudeValue"
                            value={formData.latitudeValue}
                            onChange={handleInputChange}
                            min="0"
                            max="90"
                            step="0.01"
                            className={`flex-1 px-4 py-2 bg-[#0F172A] border-y border-l ${
                              errors.latitudeValue ? 'border-red-500' : 'border-[#76EAD7]/20'
                            } rounded-l-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50`}
                            placeholder="E.g., 40.71"
                            disabled={isSubmitting}
                          />
                          <select
                            name="latitudeDirection"
                            value={formData.latitudeDirection}
                            onChange={(e) => handleDirectionChange('latitudeDirection', e.target.value)}
                            className="px-2 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-r-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50"
                            disabled={isSubmitting}
                          >
                            <option value="N">N</option>
                            <option value="S">S</option>
                          </select>
                        </div>
                        {errors.latitudeValue && (
                          <p className="mt-1 text-sm text-red-400">{errors.latitudeValue}</p>
                        )}
                      </div>
                      
                      {/* Longitude */}
                      <div>
                        <label className="block text-[#94A3B8] text-sm mb-2" htmlFor="longitudeValue">
                          Longitude
                        </label>
                        <div className="flex">
                          <input
                            type="number"
                            id="longitudeValue"
                            name="longitudeValue"
                            value={formData.longitudeValue}
                            onChange={handleInputChange}
                            min="0"
                            max="180"
                            step="0.01"
                            className={`flex-1 px-4 py-2 bg-[#0F172A] border-y border-l ${
                              errors.longitudeValue ? 'border-red-500' : 'border-[#76EAD7]/20'
                            } rounded-l-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50`}
                            placeholder="E.g., 74.01"
                            disabled={isSubmitting}
                          />
                          <select
                            name="longitudeDirection"
                            value={formData.longitudeDirection}
                            onChange={(e) => handleDirectionChange('longitudeDirection', e.target.value)}
                            className="px-2 py-2 bg-[#0F172A] border border-[#76EAD7]/20 rounded-r-lg text-white focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/50"
                            disabled={isSubmitting}
                          >
                            <option value="E">E</option>
                            <option value="W">W</option>
                          </select>
                        </div>
                        {errors.longitudeValue && (
                          <p className="mt-1 text-sm text-red-400">{errors.longitudeValue}</p>
                        )}
                      </div>
                    </div>
                    
                    <p className="mt-2 text-xs text-[#94A3B8]">
                      Enter the location where the sustainability project or initiative took place
                    </p>
                  </div>
                  
                  {/* Submit Button */}
                  <div className="pt-4">
                    <button
                      type="submit"
                      disabled={isSubmitting}
                      className={`w-full py-3 rounded-lg font-medium transition-all
                        ${isSubmitting 
                          ? 'bg-[#76EAD7]/30 text-white cursor-not-allowed' 
                          : 'bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] hover:shadow-lg'
                        }`}
                    >
                      {isSubmitting ? (
                        <div className="flex items-center justify-center">
                          <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-[#0F172A] mr-2"></div>
                          <span>Submitting to Blockchain...</span>
                        </div>
                      ) : (
                        'Submit Report'
                      )}
                    </button>
                    
                    <p className="mt-3 text-center text-xs text-[#94A3B8]">
                      This will require a blockchain transaction. Make sure you're connected to the Sepolia testnet.
                    </p>
                  </div>
                </div>
              </form>
            )}
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
};

export default ReportSubmissionModal; 