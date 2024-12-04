import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Box, Button, Typography, LinearProgress } from '@mui/material';
import CloudUploadIcon from '@mui/icons-material/CloudUpload';

const ImageUpload = ({ imageUrl, setImageUrl, error ,getUser =()=>{} }) => {
  const [file, setFile] = useState(null);
  const [message, setMessage] = useState('');
  const [progress, setProgress] = useState(0);

  // useEffect(()=>{
  //   getUser();
  // },[]);

  const handleFileChange = async (event) => {
    const selectedFile = event.target.files[0];
    setFile(selectedFile);
    setMessage('');
    setProgress(0);

    if (selectedFile) {
      const formData = new FormData();
      formData.append('image', selectedFile);

      try {
        const response = await axios.post('http://localhost:8000/api/upload', formData ,{
          withCredentials: true ,
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          onUploadProgress: (progressEvent) => {
            const percentCompleted = Math.round((progressEvent.loaded * 100) / progressEvent.total);
            setProgress(percentCompleted);
          },
        });

        setImageUrl(response.data.file.location);
        setMessage('Upload successful!');
      } catch (err) {
        const errorMsg = err.response?.data?.message || 'Error uploading file.';
        setMessage(errorMsg);
        console.error(err);
      }
    }
  };

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', mt: 2, p: 2, border: '1px solid #ddd', borderRadius: 2 }}>
      <Button
        variant="contained"
        component="label"
        startIcon={<CloudUploadIcon />}
        sx={{ mb: 2 }}
        color="primary"
      >
        Choose File
        <input
          type="file"
          hidden
          onChange={handleFileChange}
        />
      </Button>

      {progress > 0 && (
        <Box sx={{ width: '100%', mt: 1 }}>
          <LinearProgress variant="determinate" value={progress} />
          <Typography variant="body2" color="textSecondary" align="center">{`${progress}%`}</Typography>
        </Box>
      )}

      {message && (
        <Typography variant="body1" color={message === 'Upload successful!' ? 'green' : 'error'}>{message}</Typography>
      )}

      {imageUrl && (
        <Box sx={{ mt: 2 }}>
          <Typography variant="body2" color="textSecondary">Uploaded Image:</Typography>
          <img src={imageUrl} alt="uploaded" style={{ maxWidth: '100%', maxHeight: 200 }} />
        </Box>
      )}

      {error && <Typography color="error">{error}</Typography>}
    </Box>
  );
};

export default ImageUpload;
